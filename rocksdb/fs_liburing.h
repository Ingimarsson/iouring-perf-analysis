#pragma once

#include "rocksdb/env.h"
#include "rocksdb/io_status.h"
#include "rocksdb/file_system.h"
#include "rocksdb/status.h"
#include "util/thread_local.h"

namespace ROCKSDB_NAMESPACE {
    std::unique_ptr<ROCKSDB_NAMESPACE::FileSystem> NewLiburingFileSystem();

    class LiburingFileSystem : public FileSystemWrapper {
        private:
            std::unique_ptr<ThreadLocalPtr> thread_local_io_urings_;
        public:
            // No copying allowed
            LiburingFileSystem(std::shared_ptr<FileSystem> t);
            ~LiburingFileSystem(){};

            const char *Name() const;

            // void SupportedOps(int64_t& supported_ops) override;

            IOStatus NewRandomAccessFile(const std::string &fname, const FileOptions & /* file_opts */, std::unique_ptr<FSRandomAccessFile> *result, IODebugContext * /* dbg */);

            // IOStatus NewSequentialFile(const std::string &fname, const FileOptions &file_opts, std::unique_ptr<FSSequentialFile> *result, IODebugContext *dbg);

            // IOStatus NewWritableFile(const std::string &fname, const FileOptions &file_opts, std::unique_ptr<FSWritableFile> *result, IODebugContext *dbg);

            // IOStatus ReopenWritableFile(const std::string &, const FileOptions &, std::unique_ptr<FSWritableFile> *, IODebugContext *);

            // IOStatus ReuseWritableFile(const std::string &fname, const std::string &old_fname, const FileOptions &file_opts, std::unique_ptr<FSWritableFile> *result, IODebugContext *dbg);

            // IOStatus NewRandomRWFile(const std::string &, const FileOptions &, std::unique_ptr<FSRandomRWFile> *, IODebugContext *);
    };
}
