#/bin/bash

sleep 10

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=1
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=1 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=2
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=2 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=4
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=4 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=8
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=8 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=16
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=16 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=32
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=32 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=64
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=64 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=128
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=128 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=256
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=256 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=512
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=512 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=1024
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=1024 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=2048
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=2048 --coop_taskrun

sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=4096
sudo taskset -c 10 /mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --thinkcycles=4096 --coop_taskrun
