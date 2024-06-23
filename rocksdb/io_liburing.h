#pragma once

#include "rocksdb/env.h"
#include "rocksdb/io_status.h"
#include "rocksdb/file_system.h"
#include "rocksdb/status.h"
#include "util/thread_local.h"

#include <liburing.h>
#include <sys/uio.h>

namespace ROCKSDB_NAMESPACE {
    class LiburingRandomAccessFile : public FSRandomAccessFile {
        private:
            int _fd;
            std::string _path;
            unsigned int kIoUringDepth;
	    size_t logical_sector_size_;
	    const bool use_direct_io_;
            ThreadLocalPtr* thread_local_io_urings_;

            bool IsSectorAligned(const size_t off, size_t sector_size);

            void UpdateResult(struct io_uring_cqe* cqe, const std::string& file_name,
                         size_t len, size_t iov_len, bool async_read,
                         bool use_direct_io, size_t alignment,
                         size_t& finished_len, FSReadRequest* req,
                         size_t& bytes_read, bool& read_again);
            
        public:
            explicit LiburingRandomAccessFile(class LiburingFileSystem* /* fs */, int fd, std::string path, size_t logical_block_size, const EnvOptions& options, ThreadLocalPtr* thread_local_io_urings) : 
		    _fd(fd), 
		    _path(path), 
		    kIoUringDepth(256), 
		    logical_sector_size_(logical_block_size), 
		    use_direct_io_(options.use_direct_reads), 
		    thread_local_io_urings_(thread_local_io_urings) {}

            IOStatus Read(uint64_t offset, size_t n, const IOOptions& options, Slice* result, char* scratch, IODebugContext* dbg) const override;

            IOStatus MultiRead(FSReadRequest* reqs, size_t num_reqs, const IOOptions& options, IODebugContext* dbg) override;

	    size_t GetRequiredBufferAlignment() const override {
	        return logical_sector_size_;
	    }

	    bool use_direct_io() const override {
	        return use_direct_io_; 
	    }
    };

    void DeleteIOUring(void* p);

    struct io_uring* CreateIOUring();
}
