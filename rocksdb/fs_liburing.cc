#include "fs_liburing.h"
#include "io_liburing.h"

#include <fcntl.h>
#include <rocksdb/utilities/object_registry.h>

namespace ROCKSDB_NAMESPACE {

extern "C" FactoryFunc<FileSystem> liburing_reg;

FactoryFunc<FileSystem> liburing_reg = ObjectLibrary::Default()->AddFactory<FileSystem>(
  "liburing", 
  [](const std::string& /* uri */, std::unique_ptr<FileSystem>* f, std::string* /* errmsg */) {
    *f = NewLiburingFileSystem();
    return f->get();
  }
);

LiburingFileSystem::LiburingFileSystem(std::shared_ptr<FileSystem> t) : FileSystemWrapper(t) {
  struct io_uring* new_io_uring = CreateIOUring();
  if (new_io_uring != nullptr) {
    thread_local_io_urings_.reset(new ThreadLocalPtr(DeleteIOUring));
    delete new_io_uring;
  }
}

const char* LiburingFileSystem::Name() const { return "LiburingFileSystem"; }

/**
IOStatus LiburingFileSystem::NewSequentialFile(const std::string &fname, const FileOptions &file_opts, std::unique_ptr<FSSequentialFile> *result, IODebugContext *dbg) {
    result->reset(new LiburingSequentialFile(this,fname));

    return IOStatus::OK();
}



IOStatus LiburingFileSystem::NewWritableFile(const std::string &fname, const FileOptions &file_opts, std::unique_ptr<FSWritableFile> *result, IODebugContext *dbg) {
    result->reset(new LiburingWritableFile(this,fname));

    return IOStatus::OK();
}
*/

IOStatus LiburingFileSystem::NewRandomAccessFile(const std::string &fname, const FileOptions & options, std::unique_ptr<FSRandomAccessFile> *result, IODebugContext * /*dbg */) {
    int flags = O_RDONLY;

    if (options.use_direct_reads && !options.use_mmap_reads) {
        flags |= O_DIRECT;
    }

    int fd = open(fname.c_str(), flags);

    result->reset(new LiburingRandomAccessFile(this, fd, fname, 4096, options, thread_local_io_urings_.get()));

    return IOStatus::OK();
}

/**
void LiburingFileSystem::SupportedOps(int64_t& supported_ops) {
  supported_ops |= (1 << FSSupportedOps::kAsyncIO);
}
*/

std::unique_ptr<FileSystem> NewLiburingFileSystem() {
  return std::unique_ptr<FileSystem>(
      new LiburingFileSystem(FileSystem::Default()));
}

}
