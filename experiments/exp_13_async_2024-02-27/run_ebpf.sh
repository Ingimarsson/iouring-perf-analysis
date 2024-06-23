#/bin/bash

sleep 5

sudo bpftrace -e 'kprobe:create_io_worker { @create = count(); } kprobe:io_worker_handle_work { @work = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --force_async"
sudo bpftrace -e 'kprobe:create_io_worker { @create = count(); } kprobe:io_worker_handle_work { @work = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting"

sudo taskset -c 0 bpftrace -e 'kprobe:create_io_worker { @create = count(); } kprobe:io_worker_handle_work { @work = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --force_async"
sudo taskset -c 0 bpftrace -e 'kprobe:create_io_worker { @create = count(); } kprobe:io_worker_handle_work { @work = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting"
