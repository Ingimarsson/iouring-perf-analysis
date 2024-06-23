#/bin/bash

sleep 30

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting --coop_taskrun

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=1 --size=512G --runtime=600 --group_reporting

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting --coop_taskrun

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=2 --size=512G --runtime=600 --group_reporting

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting --coop_taskrun

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=4 --size=512G --runtime=600 --group_reporting

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting --coop_taskrun

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=8 --size=512G --runtime=600 --group_reporting

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting --coop_taskrun

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=16 --size=512G --runtime=600 --group_reporting

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting --coop_taskrun

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=32 --size=512G --runtime=600 --group_reporting

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting --coop_taskrun
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting --coop_taskrun

sudo taskset -c 36 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting
sudo taskset -c 16 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting
sudo taskset -c 10 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting
sudo taskset -c 0 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=600 --group_reporting

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";
