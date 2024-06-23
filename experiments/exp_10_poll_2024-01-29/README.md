# Polling IRQ experiment

When trying `fio` with SQ and IO polling, we expect that the number of mode switches should be low because:

 1. there are no IRQs from the hardware
 2. there are no syscalls from the application

Assuming the app and kernel thread are pinned to a CPU, and they are never (rarely) scheduled out, the application should be able to run interrupt free.

We are interrested in "mode switches", any kind of syscall or fault/exception that goes to kernel space. That causes TLB flush and might block IOs from finishing (adding a latency to unlucky requests)

## Counting IRQs

We find that the cause is a page fault

We use eBPF with the `exit_to_user_mode_prepare` probe, which tells us how often the kernel goes back to userspace. We count the kstack to see what the kernel was doing before that.

```
sudo taskset -c 10 bpftrace -e 'kprobe:exit_to_user_mode_prepare { @[kstack] = count(); }' -c "/mnt/sdb/brynjar/fio-uring2/fio --ioengine=io_uring --rw=randread --name=liburing-test --filename=/dev/nvme2n1 --numjobs=1 --direct=1 --bs=512 --iodepth=64 --size=512G --runtime=60 --group_reporting --sqthread_poll --sqthread_poll_cpu=14 --hipri"
```

We see that most exits are going to the page fault handler, 

## Modifying fio

The bitmap that is causing the page fault is initialized like this:

```
al->map = malloc(al->map_size * sizeof(unsigned long));
```

We replace this with a `mmap` that prefaults the full memory instead of the default lazy allocation:

```
al->map = mmap(NULL, al->map_size * sizeof(unsigned long),
                PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
```

We now confirm that the number of mode switches has been reduced: 1027524 -> 8620.

## Results

Having reduced the number of faults, we investigate whether this affects performance.

The results are in `results.txt`, the modified version is called `fio-uring2-mmap` and can be seen in the command.

We see no difference in throughput, latency is same except for 99.99%.

## Conclusion

The io\_uring polling modes are sold as a syscall free and interrupt free mode of I/O, this implies more reliable performance. However applications can have faults into kernel mode for other reasons, e.g. other syscalls, page faults. We have shown that this can affect tail latencies.

Consider Optane drives that do not have tail latencies. When designing a latency sensitive program, one has to account for latencies added by the software stack (kernel), can tail latencies be added on the host side even if the device is tail-latency free? 

