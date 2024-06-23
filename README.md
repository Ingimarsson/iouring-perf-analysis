# io_uring performance analysis

This repository contains experiment scripts and artifacts for my MSc thesis on the performance of `io_uring`. The results of this work are described on https://brynjar.io/msc-thesis.

## Experiments

### Cooperative task running

1. fio single core with/without COOP flag
2. fio multi core with/without COOP flag
3. fio multi core with/without COOP flag + eBPF to count kick / reschedule calls
4. fio multi core with/without COOP flag + parallel CPU intensive processs
5. IRQs on odd numbered CPUs only - fio multi core with/without COOP flag + compare running on odd vs even numbered cores + eBPF to count kick / reschedule calls and IRQs per core
6. IRQs on odd numbered CPUs only - same as experiment 5 + run CPU intensive process on odd / even cores (inverse to fio)

### Forced asynchronous submission

### Registered files

### SQ polling

### RocksDB

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
