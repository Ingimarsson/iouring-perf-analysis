# io_uring performance analysis

This repository contains experiment scripts and artifacts for my MSc thesis on the performance of `io_uring`. The results of this work are described on https://brynjar.io/msc-thesis.

## fio liburing engine

Run the following commands to compile fio with the liburing engine

    git clone git@github.com:axboe/fio.git
    git checkout 06812a4f
    git apply this/fio/liburing.patch
    make
    ./fio ...

## RocksDB liburing backend

Run the following commands to compile RocksDB with the liburing backend

    git clone git@github.com:facebook/rocksdb.git
    git checkout 9d64ca55
    cp this/rocksdb/ plugin/liburing/
    DEBUG_LEVEL=0 ROCKSDB_PLUGINS="liburing" make -j48 db_bench
    ./db_bench ...
