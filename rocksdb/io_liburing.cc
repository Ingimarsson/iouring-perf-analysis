#include "io_liburing.h"

#include <unistd.h>
#include <iostream>

namespace ROCKSDB_NAMESPACE {
    /**
     * LiburingRandomAccessFile
    */

/**
    LiburingRandomAccessFile::LiburingRandomAccessFile(class LiburingFileSystem* fs, int fd, std::string path) {
         std::cout << "Created random access file" << path << std::endl;
    }
*/
    IOStatus LiburingRandomAccessFile::Read(uint64_t offset, size_t n, const IOOptions& /* options */, Slice* result, char* scratch, IODebugContext* /* dbg */) const {
        //std::cout << "Read " << _path << std::endl;

        IOStatus s;
        ssize_t r = -1;
        size_t left = n;
        char* ptr = scratch;
        while (left > 0) {
            r = pread(_fd, ptr, left, static_cast<off_t>(offset));
            if (r <= 0) {
            if (r == -1 && errno == EINTR) {
                continue;
            }
            break;
            }
            ptr += r;
            offset += r;
            left -= r;

            if (use_direct_io() && r % static_cast<ssize_t>(GetRequiredBufferAlignment()) != 0) {
                break;
            }
	}
        if (r < 0) {
            s = IOStatus::IOError("While pread offset " + std::to_string(offset) + " len " + std::to_string(n));
        }
        *result = Slice(scratch, (r < 0) ? 0 : n - left);
        return s;
    }

    IOStatus LiburingRandomAccessFile::MultiRead(FSReadRequest* reqs, size_t num_reqs, const IOOptions& options, IODebugContext* dbg) {
        // std::cout << "MultiRead " << _path << std::endl;
        
        if (use_direct_io()) {
            for (size_t i = 0; i < num_reqs; i++) {
                assert(IsSectorAligned(reqs[i].offset, GetRequiredBufferAlignment()));
                assert(IsSectorAligned(reqs[i].len, GetRequiredBufferAlignment()));
                assert(IsSectorAligned(reqs[i].scratch, GetRequiredBufferAlignment()));
            }
        }
        struct io_uring* iu = nullptr;
        if (thread_local_io_urings_) {
            iu = static_cast<struct io_uring*>(thread_local_io_urings_->Get());
            if (iu == nullptr) {
                iu = CreateIOUring();
                if (iu != nullptr) {
                    thread_local_io_urings_->Reset(iu);
                }
            }
        }

        // Init failed, platform doesn't support io_uring. Fall back to
        // serialized reads
        if (iu == nullptr) {
            // std::cout << "iouring not supported " << _path << std::endl;
            return FSRandomAccessFile::MultiRead(reqs, num_reqs, options, dbg);
        }

        IOStatus ios = IOStatus::OK();

        struct WrappedReadRequest {
            FSReadRequest* req;
            struct iovec iov;
            size_t finished_len;
            explicit WrappedReadRequest(FSReadRequest* r) : req(r), finished_len(0) {}
        };

        autovector<WrappedReadRequest, 32> req_wraps;
        autovector<WrappedReadRequest*, 4> incomplete_rq_list;
        std::unordered_set<WrappedReadRequest*> wrap_cache;

        for (size_t i = 0; i < num_reqs; i++) {
            req_wraps.emplace_back(&reqs[i]);
        }

        size_t reqs_off = 0;
        while (num_reqs > reqs_off || !incomplete_rq_list.empty()) {
            size_t this_reqs = (num_reqs - reqs_off) + incomplete_rq_list.size();

            // If requests exceed depth, split it into batches
            if (this_reqs > kIoUringDepth) {
            this_reqs = kIoUringDepth;
            }

            assert(incomplete_rq_list.size() <= this_reqs);
            for (size_t i = 0; i < this_reqs; i++) {
            WrappedReadRequest* rep_to_submit;
            if (i < incomplete_rq_list.size()) {
                rep_to_submit = incomplete_rq_list[i];
            } else {
                rep_to_submit = &req_wraps[reqs_off++];
            }
            assert(rep_to_submit->req->len > rep_to_submit->finished_len);
            rep_to_submit->iov.iov_base =
                rep_to_submit->req->scratch + rep_to_submit->finished_len;
            rep_to_submit->iov.iov_len =
                rep_to_submit->req->len - rep_to_submit->finished_len;

            struct io_uring_sqe* sqe;
            sqe = io_uring_get_sqe(iu);
            io_uring_prep_readv(
                sqe, _fd, &rep_to_submit->iov, 1,
                rep_to_submit->req->offset + rep_to_submit->finished_len);
            io_uring_sqe_set_data(sqe, rep_to_submit);

	    // Uncomment to enable forced async
            // io_uring_sqe_set_flags(sqe, IOSQE_ASYNC);

            wrap_cache.emplace(rep_to_submit);
            }
            incomplete_rq_list.clear();

            ssize_t ret = io_uring_submit_and_wait(iu, static_cast<unsigned int>(this_reqs));

            if (static_cast<size_t>(ret) != this_reqs) {
            fprintf(stderr, "ret = %ld this_reqs: %ld\n", (long)ret, (long)this_reqs);
            // If error happens and we submitted fewer than expected, it is an
            // exception case and we don't retry here. We should still consume
            // what is is submitted in the ring.
            for (ssize_t i = 0; i < ret; i++) {
                struct io_uring_cqe* cqe = nullptr;
                io_uring_wait_cqe(iu, &cqe);
                if (cqe != nullptr) {
                io_uring_cqe_seen(iu, cqe);
                }
            }
            return IOStatus::IOError("io_uring_submit_and_wait() requested " +
                                    std::to_string(this_reqs) + " but returned " +
                                    std::to_string(ret));
            }

            for (size_t i = 0; i < this_reqs; i++) {
            struct io_uring_cqe* cqe = nullptr;
            WrappedReadRequest* req_wrap;

            // We could use the peek variant here, but this seems safer in terms
            // of our initial wait not reaping all completions
            ret = io_uring_wait_cqe(iu, &cqe);

            if (ret) {
                ios = IOStatus::IOError("io_uring_wait_cqe() returns " +
                                        std::to_string(ret));

                if (cqe != nullptr) {
                io_uring_cqe_seen(iu, cqe);
                }
                continue;
            }

            req_wrap = static_cast<WrappedReadRequest*>(io_uring_cqe_get_data(cqe));
            // Reset cqe data to catch any stray reuse of it
            static_cast<struct io_uring_cqe*>(cqe)->user_data = 0xd5d5d5d5d5d5d5d5;
            // Check that we got a valid unique cqe data
            auto wrap_check = wrap_cache.find(req_wrap);
            if (wrap_check == wrap_cache.end()) {
                fprintf(stderr,
                        "PosixRandomAccessFile::MultiRead: "
                        "Bad cqe data from IO uring - %p\n",
                        req_wrap);
                // port::PrintStack();
                ios = IOStatus::IOError("io_uring_cqe_get_data() returned " +
                                        std::to_string((uint64_t)req_wrap));
                continue;
            }
            wrap_cache.erase(wrap_check);

            FSReadRequest* req = req_wrap->req;
            size_t bytes_read = 0;
            bool read_again = false;
            UpdateResult(cqe, _path, req->len, req_wrap->iov.iov_len,
                        false /*async_read*/, use_direct_io(),
                        GetRequiredBufferAlignment(), req_wrap->finished_len, req,
                        bytes_read, read_again);
            int32_t res = cqe->res;
            if (res >= 0) {
                if (bytes_read == 0) {
                if (read_again) {
                    Slice tmp_slice;
                    req->status =
                        Read(req->offset + req_wrap->finished_len,
                            req->len - req_wrap->finished_len, options, &tmp_slice,
                            req->scratch + req_wrap->finished_len, dbg);
                    req->result =
                        Slice(req->scratch, req_wrap->finished_len + tmp_slice.size());
                }
                // else It means EOF so no need to do anything.
                } else if (bytes_read < req_wrap->iov.iov_len) {
                incomplete_rq_list.push_back(req_wrap);
                }
            }
            io_uring_cqe_seen(iu, cqe);
            }
            wrap_cache.clear();
        }
        return ios;
    }

    struct io_uring* CreateIOUring() {
        struct io_uring* new_io_uring = new struct io_uring;
        struct io_uring_params* uring_params;
		
	uring_params = (struct io_uring_params*) calloc (1, sizeof(*uring_params));;

	// Change to enable SQPOLL
	if (true) {
        	uring_params->flags |= IORING_SETUP_SQPOLL;

		 uring_params->flags |= IORING_SETUP_SQ_AFF;
		 uring_params->sq_thread_cpu = 12;
	}

	// Change to enable COOP
	if (false) {
        	uring_params->flags |= IORING_SETUP_COOP_TASKRUN;
	}

        int ret = io_uring_queue_init_params(256, new_io_uring, uring_params);
        //int ret = io_uring_queue_init(256, new_io_uring, 0);

        if (ret) {
		std::cout << "create error " << ret << std::endl;
            delete new_io_uring;
            new_io_uring = nullptr;
        }
	else {
		std::cout << "success" << std::endl;
	}
        return new_io_uring;
    }

    bool LiburingRandomAccessFile::IsSectorAligned(const size_t off, size_t sector_size) {
        assert((sector_size & (sector_size - 1)) == 0);
        return (off & (sector_size - 1)) == 0;
    }

    void LiburingRandomAccessFile::UpdateResult(struct io_uring_cqe* cqe, const std::string& /* file_name */,
                         size_t /* len */, size_t iov_len, bool async_read,
                         bool use_direct_io, size_t alignment,
                         size_t& finished_len, FSReadRequest* req,
                         size_t& bytes_read, bool& read_again) {
        read_again = false;
        if (cqe->res < 0) {
            req->result = Slice(req->scratch, 0);
            req->status = IOStatus::IOError("Req failed " + std::to_string(cqe->res));
        } else {
            bytes_read = static_cast<size_t>(cqe->res);
            if (bytes_read == iov_len) {
                req->result = Slice(req->scratch, req->len);
                req->status = IOStatus::OK();
            } else if (bytes_read == 0) {
            /// cqe->res == 0 can means EOF, or can mean partial results. See
            // comment
            // https://github.com/facebook/rocksdb/pull/6441#issuecomment-589843435
            // Fall back to pread in this case.
            if (use_direct_io && !IsSectorAligned(finished_len, alignment)) {
                // Bytes reads don't fill sectors. Should only happen at the end
                // of the file.
                req->result = Slice(req->scratch, finished_len);
                req->status = IOStatus::OK();
            } else {
                if (async_read) {
                // No  bytes read. It can means EOF. In case of partial results, it's
                // caller responsibility to call read/readasync again.
                req->result = Slice(req->scratch, 0);
                req->status = IOStatus::OK();
                } else {
                read_again = true;
                }
            }
            } else if (bytes_read < iov_len) {
                assert(bytes_read > 0);
                if (async_read) {
                    req->result = Slice(req->scratch, bytes_read);
                    req->status = IOStatus::OK();
                } else {
                    assert(bytes_read + finished_len < len);
                    finished_len += bytes_read;
                }
            } else {
                req->result = Slice(req->scratch, 0);
                req->status = IOStatus::IOError("Req returned more bytes than requested");
            }
        }
    }
}
