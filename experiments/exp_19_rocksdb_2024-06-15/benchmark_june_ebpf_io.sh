#!/bin/bash

sudo taskset -c 10 bpftrace -e "tracepoint:block:block_rq_issue { @ = hist(args->bytes); @iops = count(); }" -c "./db_bench_def --benchmarks=multireadrandom --fs_uri=posix --use_existing_db --db=/mnt/nvme2n1/experiment/ --key_size=100 --value_size=100 --num=1000000 --compression_type=none --seed=123456789 --use_direct_reads --batch_size=4 --multiread_stride=40000 --multiread_batched=true"

sudo taskset -c 10 bpftrace -e "tracepoint:block:block_rq_issue { @ = hist(args->bytes); @iops = count(); }" -c "./db_bench_def --benchmarks=multireadrandom --fs_uri=posix --use_existing_db --db=/mnt/nvme2n1/experiment/ --key_size=100 --value_size=100 --num=1000000 --compression_type=none --seed=123456789 --use_direct_reads --batch_size=4 --multiread_stride=40000 --multiread_batched=true --async_io=false --io_uring_enabled=false --statistics=1"

sudo taskset -c 10 bpftrace -e "tracepoint:block:block_rq_issue { @ = hist(args->bytes); @iops = count(); }" -c "./db_bench_def --benchmarks=multireadrandom --fs_uri=liburing --use_existing_db --db=/mnt/nvme2n1/experiment/ --key_size=100 --value_size=100 --num=1000000 --compression_type=none --seed=123456789 --use_direct_reads --batch_size=4 --multiread_stride=40000 --multiread_batched=true"

sudo taskset -c 10 bpftrace -e "tracepoint:block:block_rq_issue { @ = hist(args->bytes); @iops = count(); }" -c "./db_bench_coop --benchmarks=multireadrandom --fs_uri=liburing --use_existing_db --db=/mnt/nvme2n1/experiment/ --key_size=100 --value_size=100 --num=1000000 --compression_type=none --seed=123456789 --use_direct_reads --batch_size=4 --multiread_stride=40000 --multiread_batched=true"

sudo taskset -c 10 bpftrace -e "tracepoint:block:block_rq_issue { @ = hist(args->bytes); @iops = count(); }" -c "./db_bench_sq --benchmarks=multireadrandom --fs_uri=liburing --use_existing_db --db=/mnt/nvme2n1/experiment/ --key_size=100 --value_size=100 --num=1000000 --compression_type=none --seed=123456789 --use_direct_reads --batch_size=4 --multiread_stride=40000 --multiread_batched=true"

sudo taskset -c 10 bpftrace -e "tracepoint:block:block_rq_issue { @ = hist(args->bytes); @iops = count(); }" -c "./db_bench_async --benchmarks=multireadrandom --fs_uri=liburing --use_existing_db --db=/mnt/nvme2n1/experiment/ --key_size=100 --value_size=100 --num=1000000 --compression_type=none --seed=123456789 --use_direct_reads --batch_size=4 --multiread_stride=40000 --multiread_batched=true"


