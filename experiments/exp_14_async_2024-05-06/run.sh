#/bin/bash

sleep 5

sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=1 --size=1G --io_size=512G --runtime=60 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=2 --size=1G --io_size=512G --runtime=60 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=4 --size=1G --io_size=512G --runtime=60 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=8 --size=1G --io_size=512G --runtime=60 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=16 --size=1G --io_size=512G --runtime=60 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=32 --size=1G --io_size=512G --runtime=60 --group_reporting --force_async
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=64 --size=1G --io_size=512G --runtime=60 --group_reporting --force_async

sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=1 --size=1G --io_size=512G --runtime=60 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=2 --size=1G --io_size=512G --runtime=60 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=4 --size=1G --io_size=512G --runtime=60 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=8 --size=1G --io_size=512G --runtime=60 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=16 --size=1G --io_size=512G --runtime=60 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=32 --size=1G --io_size=512G --runtime=60 --group_reporting
sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=2 --direct=1 --bs=512 --iodepth=64 --size=1G --io_size=512G --runtime=60 --group_reporting

