#/bin/bash

sleep 10

sudo taskset -c 10 bpftrace -e 'tracepoint:irq_vectors:reschedule_entry { @ipi = count(); } kprobe:exit_to_user_mode_prepare { @stack[kstack] = count(); }' -c "/mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=60 --group_reporting --thinkcycles=512"
sudo taskset -c 10 bpftrace -e 'tracepoint:irq_vectors:reschedule_entry { @ipi = count(); } kprobe:exit_to_user_mode_prepare { @stack[kstack] = count(); }' -c "/mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=60 --group_reporting --thinkcycles=1024"
sudo taskset -c 10 bpftrace -e 'tracepoint:irq_vectors:reschedule_entry { @ipi = count(); } kprobe:exit_to_user_mode_prepare { @stack[kstack] = count(); }' -c "/mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=60 --group_reporting --thinkcycles=2048"
sudo taskset -c 10 bpftrace -e 'tracepoint:irq_vectors:reschedule_entry { @ipi = count(); } kprobe:exit_to_user_mode_prepare { @stack[kstack] = count(); }' -c "/mnt/sdb/brynjar/fio-thinkcycles/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=60 --group_reporting --thinkcycles=4096"

