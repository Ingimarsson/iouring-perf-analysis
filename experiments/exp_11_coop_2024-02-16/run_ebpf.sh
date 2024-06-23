#/bin/bash

sleep 5

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 1"
sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 1 coop"

sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 2"
sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 2 coop"

sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 4"
sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 4 coop"

sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 8"
sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 8 coop"

sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 16"
sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 16 coop"

sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 32"
sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 32 coop"

sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 64"
sudo bpftrace -e 'kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } kprobe:kick_process { @kick[cpu] = count(); } kprobe:task_work_add { @b["task_work_add"] = count(); } kretfunc:vmlinux:wake_up_state { @wake[retval] = count(); } kprobe:nvme_irq { @c[arg0] = count(); }' -c "./main /dev/nvme2n1 64 coop"

