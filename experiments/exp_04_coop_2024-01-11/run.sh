#/bin/bash

taskset -c 0 ./busy &
taskset -c 0 ./busy &
taskset -c 0 ./busy &
taskset -c 0 ./busy &

taskset -c 1 ./busy &
taskset -c 1 ./busy &
taskset -c 1 ./busy &
taskset -c 1 ./busy &

taskset -c 2 ./busy &
taskset -c 2 ./busy &
taskset -c 2 ./busy &
taskset -c 2 ./busy &

taskset -c 3 ./busy &
taskset -c 3 ./busy &
taskset -c 3 ./busy &
taskset -c 3 ./busy &

sleep 30

taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=300 --group_reporting
taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=300 --group_reporting --coop_taskrun

taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=300 --group_reporting
taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=300 --group_reporting --coop_taskrun

taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=300 --group_reporting
taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=300 --group_reporting --coop_taskrun

taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=300 --group_reporting
taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=300 --group_reporting --coop_taskrun

taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=300 --group_reporting
taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=300 --group_reporting --coop_taskrun

taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=300 --group_reporting
taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=300 --group_reporting --coop_taskrun

taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting
taskset -c 0-3 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --coop_taskrun

kill %4
kill %3
kill %2
kill %1

