liburing_SOURCES = io_liburing.cc fs_liburing.cc
liburing_HEADERS = io_liburing.h fs_liburing.h
liburing_LDFLAGS = -luring -u liburing_reg
