# RocksDB evaluation

## Setup

Compile RocksDB with plugin

    DEBUG_LEVEL=0 ROCKSDB_PLUGINS="liburing" make -j48 db_bench

Create FS

    mkfs.ext4 /dev/nvme2n1
    mount /dev/nvmen1 /mnt/nvme2n1

Initialize database

    ./db_bench --benchmarks=fillrandom --fs_uri=posix --db=/mnt/nvme2n1/rocksdb3/ --key_size=100 --value_size=1000000 --num=10000 --compression_type=none --seed=123456789

Run benchmark

    ./db_bench --benchmarks=multireadrandom --fs_uri=posix --db=/mnt/nvme2n1/rocksdb3/ --use_existing_db --compression_type=none --seed=123456789 --async_io=true --key_size=100 --value_size=1000000 --num=10000 --io_uring_enabled=false
    ./db_bench --benchmarks=multireadrandom --fs_uri=posix --db=/mnt/nvme2n1/rocksdb3/ --use_existing_db --compression_type=none --seed=123456789 --async_io=true --key_size=100 --value_size=1000000 --num=10000
    ./db_bench --benchmarks=multireadrandom --fs_uri=liburing --db=/mnt/nvme2n1/rocksdb3/ --use_existing_db --compression_type=none --seed=123456789 --async_io=true --key_size=100 --value_size=1000000 --num=10000

