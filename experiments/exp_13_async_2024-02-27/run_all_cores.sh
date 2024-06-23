#/bin/bash

sleep 5

sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=300 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=300 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=300 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=300 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=300 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=300 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting --force_async

sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=300 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=300 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=300 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=300 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=300 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=300 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=300 --group_reporting

