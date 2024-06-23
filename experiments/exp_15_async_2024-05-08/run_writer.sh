#/bin/bash

sleep 5

sudo /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randwrite --name=liburing-test --filename=/mnt/nvme2n1/file --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=1G --io_size=512G --runtime=1000 --group_reporting
