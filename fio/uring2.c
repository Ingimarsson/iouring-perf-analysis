/*
 * liburing engine
 *
 * IO engine using the new native Linux aio io_uring interface. See:
 *
 * http://git.kernel.dk/cgit/linux-block/log/?h=io_uring
 *
 */
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/resource.h>

#include "../fio.h"
#include "../lib/pow2.h"
#include "../optgroup.h"
#include "../lib/memalign.h"
#include "../lib/fls.h"
#include "../lib/roundup.h"

#ifdef ARCH_HAVE_IOURING

#include "../lib/types.h"
#include "cmdprio.h"
#include "nvme.h"

#include <sys/stat.h>

#include <liburing.h>

#define CHECK_FLAG(X) do {\
    if(flags & X){\
        printf ("\t %s: \t yes\n", #X);\
    } else{\
        printf ("\t %s: \t no\n", #X);\
    }\
}while(0);

#define CHECK_FEATURE(X) do {\
    if(features & X){\
        printf ("\t %s: \t yes\n", #X);\
    } else{\
        printf ("\t %s: \t no\n", #X);\
    }\
}while(0);

#define DBG_ERR              0x00000001
#define DBG_INFO            0x00000002
#define DBG_ON              0x00000004
#define DBG_BENCH1          0x00000010

#define DBG_ALL         (DBG_ERR|DBG_INFO|DBG_ON|DBG_BENCH1)
#define DPRINT_MASK     (DBG_ON|DBG_ERR|DBG_ALL)

#define dprint_err(__err, fmt, args...)\
        do {\
                if (true) {     \
                    printf("[%s:%d %s] "fmt, __func__, __LINE__, strerror((__err > 0 ? __err : (0 - __err))), args); \
                }\
        } while (0)

#ifdef NODEBUG
#define dprintf(dbgcat, fmt, args...) void(0)
#else
#define dprintf(dbgcat, fmt, args...)\
        do {\
                if ((dbgcat) & DPRINT_MASK) {\
                    printf("[%s:%d] "fmt, __func__, __LINE__, args); \
                }\
        } while (0)
#endif

static int utils_print_sqring_offsets(struct io_sqring_offsets *p){
    if(p) {
        int flags = p->flags;
        printf("\tSize of the struct io_sqring_offsets is %lu \n", sizeof(*p));
        printf("\thead: %u tail: %u ring_mask: 0x%x ring_entires: %u \n", p->head, p->tail, p->ring_mask, p->ring_entries);
        printf("\tflags: 0x%x dropped: %u array: %u \n", p->flags, p->dropped, p->array);
        // where to find these flags, in the io_uring.h file, line 410, sq_ring->flags 
        CHECK_FLAG(IORING_SQ_NEED_WAKEUP);
        CHECK_FLAG(IORING_SQ_CQ_OVERFLOW);
        CHECK_FLAG(IORING_SQ_TASKRUN);
    }
    return 0;
}

static int utils_print_cqring_offsets(struct io_cqring_offsets *p){
    if(p) {
        int flags = p->flags;
        printf("\tSize of the struct io_sqring_offsets is %lu \n", sizeof(*p));
        printf("\thead: %u tail: %u ring_mask: 0x%x ring_entires: %u \n", p->head, p->tail, p->ring_mask, p->ring_entries);
        printf("\toverflow: %u cqes: %u flasgs: 0x%x \n", p->overflow, p->cqes, p->flags);
        // where to find these flags, in the io_uring.h file, line 432, cq_ring->flags 
        CHECK_FLAG(IORING_CQ_EVENTFD_DISABLED);
    }
    return 0;
}

static int utils_print_setup_flags(__u32 flags){
    printf("---- showing flags in struct io_uring_params ---- \n");
    printf("raw hex value of the io_uring_params flag: 0x%x \n", flags);
    CHECK_FLAG(IORING_SETUP_IOPOLL);
    CHECK_FLAG(IORING_SETUP_SQPOLL);
    CHECK_FLAG(IORING_SETUP_SQ_AFF);
    CHECK_FLAG(IORING_SETUP_CQSIZE);
    CHECK_FLAG(IORING_SETUP_CLAMP);
    CHECK_FLAG(IORING_SETUP_ATTACH_WQ);
    CHECK_FLAG(IORING_SETUP_R_DISABLED);
    CHECK_FLAG(IORING_SETUP_SUBMIT_ALL);
    CHECK_FLAG(IORING_SETUP_COOP_TASKRUN);
    CHECK_FLAG(IORING_SETUP_TASKRUN_FLAG);
    CHECK_FLAG(IORING_SETUP_SQE128);
    CHECK_FLAG(IORING_SETUP_CQE32);
    CHECK_FLAG(IORING_SETUP_SINGLE_ISSUER);
    CHECK_FLAG(IORING_SETUP_DEFER_TASKRUN);
    return 0;
    printf("==== **** ==== \n");
}

static int utils_print_kernel_features(__u32 features){
    printf("---- showing features in struct io_uring_params ---- \n");
    printf("raw hex value of the io_uring_params feature : 0x%x \n", features);
    CHECK_FEATURE(IORING_FEAT_SINGLE_MMAP);
    CHECK_FEATURE(IORING_FEAT_NODROP);
    CHECK_FEATURE(IORING_FEAT_SUBMIT_STABLE);
    CHECK_FEATURE(IORING_FEAT_RW_CUR_POS);
    CHECK_FEATURE(IORING_FEAT_CUR_PERSONALITY);
    CHECK_FEATURE(IORING_FEAT_FAST_POLL);
    CHECK_FEATURE(IORING_FEAT_POLL_32BITS);
    CHECK_FEATURE(IORING_FEAT_SQPOLL_NONFIXED);
    // This feature is renmaed in the future kernel verions, this is done for 6.3 
    // CHECK_FEATURE(IORING_FEAT_ENTER_EXT_ARG); -- https://man.archlinux.org/man/io_uring_setup.2.en 
    CHECK_FEATURE(IORING_FEAT_EXT_ARG);
    CHECK_FEATURE(IORING_FEAT_NATIVE_WORKERS);
    CHECK_FEATURE(IORING_FEAT_RSRC_TAGS);
    CHECK_FEATURE(IORING_FEAT_CQE_SKIP);
    CHECK_FEATURE(IORING_FEAT_LINKED_FILE);
    //CHECK_FEATURE(IORING_FEAT_REG_REG_RING);
    printf("==== **** ==== \n");
    return 0;
}

static int utils_print_iou_params(struct io_uring_params *p) {
    if(p) {
        printf("Size of the struct io_uring_params is (bytes): %lu \n", sizeof(*p));
        printf("sq_entries: %u cq_entries: %u \n", p->sq_entries, p->cq_entries);
        utils_print_setup_flags(p->flags);
        utils_print_kernel_features(p->features);
        printf("sq_thread_cpu: %u sq_thread_idle: %u \n", p->sq_thread_cpu, p->sq_thread_idle);
        printf("features 0x%x \n", p->features);
        utils_print_sqring_offsets(&p->sq_off);
        utils_print_cqring_offsets(&p->cq_off);
    }
    return 0;
}

struct uring_data {
    struct io_uring *ring;
    struct io_u **io_u_index;
    struct iovec *iovecs;
    struct io_uring_cqe **cqes;
    int *fds;
    int cqe_offset;
    int cqe_events;
    int queued;
    unsigned iodepth;
};

struct uring_options {
    struct thread_data *td;
    unsigned int hipri;
    struct cmdprio_options cmdprio_options;
    unsigned int fixedbufs;
    unsigned int registerfiles;
    unsigned int sqpoll_thread;
    unsigned int sqpoll_set;
    unsigned int sqpoll_cpu;
    unsigned int nonvectored;
    unsigned int uncached;
    unsigned int nowait;
    unsigned int force_async;
    unsigned int md_per_io_size;
    unsigned int pi_act;
    unsigned int apptag;
    unsigned int apptag_mask;
    unsigned int prchk;
    char *pi_chk;
    //
    unsigned int coop_taskrun;
    unsigned int atr_debug;
};

static int fio_uring_sqpoll_cb(void *data, unsigned long long *val)
{
	struct uring_options *o = data;

	o->sqpoll_cpu = *val;
	o->sqpoll_set = 1;
	return 0;
}

static struct fio_option uring_params[] = {
        {
                .name	= "atr_debug",
                .lname	= "atr debug",
                .type	= FIO_OPT_STR_SET,
                .off1	= offsetof(struct uring_options, atr_debug),
                .help	= "enable atr debugging prints",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "coop_taskrun",
                .lname	= "IORING_SETUP_COOP_TASKRUN",
                .type	= FIO_OPT_STR_SET,
                .off1	= offsetof(struct uring_options, coop_taskrun),
                .help	= "sets IORING_SETUP_COOP_TASKRUN, see https://man.archlinux.org/man/io_uring_setup.2.en#IORING_SETUP_COOP_TASKRUN",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "hipri",
                .lname	= "High Priority",
                .type	= FIO_OPT_STR_SET,
                .off1	= offsetof(struct uring_options, hipri),
                .help	= "Use polled IO completions",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "fixedbufs",
                .lname	= "Fixed (pre-mapped) IO buffers",
                .type	= FIO_OPT_STR_SET,
                .off1	= offsetof(struct uring_options, fixedbufs),
                .help	= "Pre map IO buffers",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "registerfiles",
                .lname	= "Register file set",
                .type	= FIO_OPT_STR_SET,
                .off1	= offsetof(struct uring_options, registerfiles),
                .help	= "Pre-open/register files",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "sqthread_poll",
                .lname	= "Kernel SQ thread polling",
                .type	= FIO_OPT_STR_SET,
                .off1	= offsetof(struct uring_options, sqpoll_thread),
                .help	= "Offload submission/completion to kernel thread",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "sqthread_poll_cpu",
                .lname	= "SQ Thread Poll CPU",
                .type	= FIO_OPT_INT,
                .cb	= fio_uring_sqpoll_cb,
                .help	= "What CPU to run SQ thread polling on",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "nonvectored",
                .lname	= "Non-vectored",
                .type	= FIO_OPT_INT,
                .off1	= offsetof(struct uring_options, nonvectored),
                .def	= "-1",
                .help	= "Use non-vectored read/write commands",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "uncached",
                .lname	= "Uncached",
                .type	= FIO_OPT_INT,
                .off1	= offsetof(struct uring_options, uncached),
                .help	= "Use RWF_UNCACHED for buffered read/writes",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "nowait",
                .lname	= "RWF_NOWAIT",
                .type	= FIO_OPT_BOOL,
                .off1	= offsetof(struct uring_options, nowait),
                .help	= "Use RWF_NOWAIT for reads/writes",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        {
                .name	= "force_async",
                .lname	= "Force async",
                .type	= FIO_OPT_STR_SET,
                .off1	= offsetof(struct uring_options, force_async),
                .help	= "Set IOSQE_ASYNC every N requests",
                .category = FIO_OPT_C_ENGINE,
                .group	= FIO_OPT_G_IOURING,
        },
        CMDPRIO_OPTIONS(struct uring_options, FIO_OPT_G_IOURING),
        {
                .name	= NULL,
        },
};

static int fio_uring_init(struct thread_data *td)
{
    int ret = -ENOSYS;
    struct uring_data *ld = NULL;
    struct uring_options *bench_params = td->eo;
    struct io_uring_params *uring_params;

    ld = calloc(1, sizeof(*ld));
    uring_params = calloc (1, sizeof(*uring_params));

    if (bench_params->coop_taskrun) {
        uring_params->flags |= IORING_SETUP_COOP_TASKRUN;
    }

    // Initialize the ring
    ld->ring = calloc (1, sizeof(*ld->ring));
    ret = io_uring_queue_init_params(td->o.iodepth, ld->ring, uring_params);

    if(ret != 0){
        log_err("fio_uring_init: ring setup failed, code: %d \n", ret);
        return 1;
    }

    ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
    ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));

    // Used for getevents() and event()
    ld->cqes = calloc(td->o.iodepth, sizeof(struct io_uring_cqe *));
    ld->cqe_offset = 0;

    ld->iodepth = td->o.iodepth;
    ld->queued = 0;

    if (bench_params->atr_debug) {
        utils_print_iou_params(uring_params);
        dprintf(DBG_BENCH1, "fio_uring_init successful, code: %d \n", ret);
    }

    // TODO: Handle registered files
    // TODO: Here we would also initialize CMD priority (cmdprio)

    td->io_ops_data = ld;

    return 0;
}

static int fio_uring_io_u_init(struct thread_data *td, struct io_u *io_u)
{
    /**
     * Order of calls:
     *  1. io_init is called
     *  2. io_u_init is called, for each unit (io_depth)
     *  3. io_post_init is called
    */
	struct uring_data *ld = td->io_ops_data;

	ld->io_u_index[io_u->index] = io_u;

	return 0;
}

static int fio_uring_post_init(struct thread_data *td)
{
    struct uring_data *ld = td->io_ops_data;

    // Map fio's IO units to our iovec structs
	for (int i = 0; i < td->o.iodepth; i++) {
		struct iovec *iov = &ld->iovecs[i];
		struct io_u *io_u = ld->io_u_index[i];

		iov->iov_base = io_u->buf;
		iov->iov_len = td_max_bs(td);
	}

    struct uring_options *bench_params = td->eo;
	struct fio_file *f;
	unsigned int i;
	int ret;

    if (bench_params->registerfiles) {
        ld->fds = calloc(td->o.nr_files, sizeof(int));

        for_each_file(td, f, i) {
            ret = generic_open_file(td, f);
            ld->fds[i] = f->fd;
            f->engine_pos = i;
        }

        io_uring_register_files(ld->ring, ld->fds, td->o.nr_files);

        for_each_file(td, f, i) {
            f->fd = -1;
        }
    }

    return 0;
}

static enum fio_q_status fio_uring_queue(struct thread_data *td,
                                         struct io_u *io_u)
{
    struct uring_options *bench_params = td->eo;
    struct uring_data *ld = td->io_ops_data;
    struct iovec *iov = &ld->iovecs[io_u->index];

    if (ld->queued == ld->iodepth) {
        return FIO_Q_BUSY;
    }

    iov->iov_base = io_u->xfer_buf;
    iov->iov_len = io_u->xfer_buflen;

    struct io_uring_sqe *sqe = io_uring_get_sqe(ld->ring);

    while (!sqe) {
        return FIO_Q_BUSY;
    }

    int fd = bench_params->registerfiles 
        ? io_u->file->engine_pos
        : io_u->file->fd;

    if (io_u->ddir == DDIR_READ) {
        io_uring_prep_readv(sqe, fd, iov, 1, io_u->offset);
    } 
    else if (io_u->ddir == DDIR_WRITE) {
        io_uring_prep_writev(sqe, fd, iov, 1, io_u->offset);
    }
    else {
        log_err("fio_uring_queue: unsupported ddir %d\n", io_u->ddir);
    }

    if (bench_params->force_async) {
        io_uring_sqe_set_flags(sqe, IOSQE_ASYNC);
    }

    if (bench_params->registerfiles) {
        io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
    }

    sqe->off = io_u->offset;

    io_uring_sqe_set_data(sqe, io_u);

    ld->queued++;

    struct timespec now;
    fio_gettime(&now, NULL);
    memcpy(&io_u->issue_time, &now, sizeof(now));
    io_u_queued(td, io_u);
    
    return FIO_Q_QUEUED;
}

static int fio_uring_commit(struct thread_data *td)
{
    struct uring_data *ld = td->io_ops_data;
    int ret;
    
    while (ld->queued) {
        ret = io_uring_submit(ld->ring);

        if (ret > 0) {
            ld->queued -= ret;
	    io_u_mark_submit(td, ld->queued);
        }
    }

    return 0;
}

static int fio_uring_getevents(struct thread_data *td, unsigned int min,
                               unsigned int max, const struct timespec *t)
{
    struct uring_data *ld = td->io_ops_data;
    struct io_uring_cqe **cqe;
    int events = 0;

    int cqe_idx = ld->cqe_offset;

    while (events < min) {
        cqe = &ld->cqes[cqe_idx];
        int ret = io_uring_wait_cqe(ld->ring, cqe);

        if (ret == 0) {
            events += 1;
        } 
        else if (ret < 0) {
            log_err("fio_uring_getevents: got error from io_uring_wait_cqe, "
                "code: %d\n", ret);
        }

        io_uring_cqe_seen(ld->ring, cqe);

        cqe_idx = (cqe_idx + 1) % ld->iodepth;
    }

    ld->cqe_offset = cqe_idx;
    ld->cqe_events = events;

    return events;
}

static struct io_u *fio_uring_event(struct thread_data *td, int event)
{
    struct uring_data *ld = td->io_ops_data;

    int cqe_idx = (ld->cqe_offset - ld->cqe_events + event) % ld->iodepth;
    struct io_uring_cqe *cqe = ld->cqes[cqe_idx];

    struct io_u *io_u = (struct io_u *) (uintptr_t) cqe->user_data;

    io_u->error = 0;
    io_u->resid = io_u->xfer_buflen - cqe->res;

    return io_u;
}

static int fio_uring_open_file(struct thread_data *td, struct fio_file *f)
{
    // TODO: Handle registered files differently

    return generic_open_file(td, f);
}

static int fio_uring_close_file(struct thread_data *td, struct fio_file *f)
{
    // TODO: Handle registered files differently

    return generic_close_file(td, f);
}

static void fio_uring_cleanup(struct thread_data *td)
{
	struct uring_data *ld = td->io_ops_data;

	if (ld) {
		free(ld->ring);
		free(ld->iovecs);
		free(ld->io_u_index);
		free(ld->cqes);
		free(ld);
	}
}

static struct ioengine_ops ioengine_liburing = {
        .name			= "liburing",
        .version		= FIO_IOOPS_VERSION,
        .flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
                            FIO_ASYNCIO_SETS_ISSUE_TIME,
        .init			= fio_uring_init,
        .io_u_init		= fio_uring_io_u_init,
        .post_init		= fio_uring_post_init,
        .queue			= fio_uring_queue,
        .commit			= fio_uring_commit,
        .getevents		= fio_uring_getevents,
        .event			= fio_uring_event,
        .cleanup		= fio_uring_cleanup,
        .open_file		= fio_uring_open_file,
        .close_file		= fio_uring_close_file,
	.get_file_size		= generic_get_file_size,
        .options		= uring_params,
        .option_struct_size	= sizeof(struct uring_options),
};

static void fio_init fio_uring_register(void)
{
    register_ioengine(&ioengine_liburing);
}

static void fio_exit fio_uring_unregister(void)
{
    unregister_ioengine(&ioengine_liburing);
}
#endif //ARCH_HAVE_IOURING
