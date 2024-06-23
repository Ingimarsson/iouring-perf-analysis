# Experiment 5 (2024-01-12)

In this experiment we turn off NVMe interrupts on half the cores and compare performance of running on interrupt cores vs non-interrupt cores.

The Linux NVMe module has no options to change IRQ affinities. We use the following trick:

```bash
modprobe -r nvme
modprove nvme poll_queues=20
```

The Optane drives have 31 queues and the machine has 20 cores, so this will leave 11 queues for non-polled use, we can see this with dmesg:

```
$ dmesg
...
[3889100.854550] nvme nvme2: 11/0/20 default/read/poll queues
```

We can see which cores the IRQs are set up:

```bash
$ for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";
19 11 13 15 17 19 1 3 5 7 8 9
```

We now run two experiments, one with eBPF counters, and one to see performance.

## eBPF results

We run fio with the following eBPF script in parallel. The script counts calls to `kick_process` and `native_smp_send_reschedule`, and it also counts IRQs sent to the NVMe module, grouped by the IRQ vector.

```c
kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } 
kprobe:kick_process { @["kick"] = count(); } 
kprobe:nvme_irq { @b[arg0] = count(); }
```

Below are the results, full output in results_ebpf.txt and results_ebpf.csv.

<p>
    <img src="result_counts.png" alt="drawing" width="45%"/>
    <img src="result_irq.png" alt="drawing" width="45%"/>
</p>

We only use CPUs 10-13 for this experiment, as they are on the NUMA node of the Optane drives. We run fio for two cores at a time, either 10 and 12 (non-interrupt cores) or 11 and 13 (interrupt cores). 

The left graph shows that `kick_process` is called for each IO, but only if `COOP_TASKRUN` is not specified. It also shows that `kick_process` does nothing on CPU 11,13 (interrupt cores), but when running on non-interrupt cores, an IPI is sent for each IO.

The right graph shows the number of NVMe IRQs coming in on CPUs 11 and 13 (all other cores had 0 IRQs). This shows that when running on non-interrupt cores (10 and 12), the interrupts still come in on the closest core with interrupts (11 and 13).

## Performance results

<p>
    <img src="result_iops.png" alt="drawing" width="30%"/>
    <img src="result_clat_avg.png" alt="drawing" width="30%"/>
    <img src="result_clat_p99.png" alt="drawing" width="30%"/>
</p>

## Profiling with perf

To find an explanation for the improved performance running on non-interrupt cores, we do perf profiling on (1) CPUs 10 and 12, (2) CPUs 11 and 13, both without COOP_TASKRUN. The results can be found in:

 - [Report CPU 10,12 (non-interrupt cores)](perf_remote.txt)
 - [Report CPU 11,13 (interrupt cores)](perf_local.txt)

We can see in the latter case, `irq_nvme` accounts for 16.5% of CPU time, very close to the 19% difference in performance. Note that freeing 16.5% of CPU time results in `1 - 1/(1 - 0.165)` or 19.8% more share for the rest.

```
sudo taskset -c 11,13 /mnt/sdb/linux_build/linux-6.3.8-local/linux-6.3.8/tools/perf/perf record -g -C 11,13 -F 200 /mnt/sdb/brynjar/fio-uring2/fio --ioengine=liburing --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=16 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=150 --group_reporting
```

## Conclusion

We conclude that the improved performance comes from having the IRQ handler running on a different core. The cost of reschedule IPIs almost counteracts the improvement, but adding the COOP_TASKRUN flag prevents IPIs.
