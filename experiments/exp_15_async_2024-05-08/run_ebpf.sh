#/bin/bash

sleep 5

sudo bpftrace -e 'kprobe:ext4_file_read_iter { @[((struct kiocb*)arg0)->ki_flags] = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=1G --io_size=512G --runtime=60 --group_reporting --force_async"
sudo bpftrace -e 'kprobe:ext4_file_read_iter { @[((struct kiocb*)arg0)->ki_flags] = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=1G --io_size=512G --runtime=60 --group_reporting"

