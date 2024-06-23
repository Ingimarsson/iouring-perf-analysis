#/bin/bash

sleep 30

/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting
/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting --coop_taskrun

/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting
/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting --coop_taskrun

/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting
/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting --coop_taskrun

/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting
/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting --coop_taskrun

/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting
/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting --coop_taskrun

/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting
/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting --coop_taskrun

/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting
/mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf stat -a -e cs -- taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1 --numjobs=4 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting --coop_taskrun

