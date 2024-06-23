#/bin/bash

sleep 5

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo taskset -c 10,12 bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @["kick"] = count(); } kprobe:nvme_irq { @b[arg0] = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=150 --group_reporting"
sudo taskset -c 10,12 bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @["kick"] = count(); } kprobe:nvme_irq { @b[arg0] = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=150 --group_reporting --coop_taskrun"

sudo taskset -c 11,13 bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @["kick"] = count(); } kprobe:nvme_irq { @b[arg0] = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=150 --group_reporting"
sudo taskset -c 11,13 bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @["kick"] = count(); } kprobe:nvme_irq { @b[arg0] = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=150 --group_reporting --coop_taskrun"

