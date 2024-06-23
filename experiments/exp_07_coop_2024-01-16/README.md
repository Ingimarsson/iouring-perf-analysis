# Experiment 7 (2024-01-16)

In this experiment we run fio on two non-interrupt cores (CPU 10, 12 like in exp. 5), as we are interested in the effect of IPIs (which do not show up on interrupt cores). We also run a CPU intensive program `busy.c` in parallel on these cores such that fio only gets ~50% of the CPU time. We want to see if using COOP_TASKRUN, and thus disabling IPIs, will affect latency. We expect that IPIs make the target CPU process completion events as soon as possible. With COOP_TASKRUN, no IPI is sent at completion, and if `busy.c` is running then completion events will only process when `busy.c`'s CPU time is up. We are trying to find a downside of using COOP_TASKRUN.

## Performance results

We run four experiments for queue depths 1-64, each with 16 fio workers on 2 non-interrupt cores (CPU 10, 12). The four combinations are: with/without COOP and with/without `busy.c`. Results for without `busy.c` are taken from experiment 5. The graphs show IOPS, average, and 99p latency:

<p>
    <img src="result_iops.png" alt="drawing" width="30%"/>
    <img src="result_clat_avg.png" alt="drawing" width="30%"/>
    <img src="result_clat_p99.png" alt="drawing" width="30%"/>
</p>

For throughput we see the same as in experiment 5: using COOP_TASKRUN on a non-interrupt core improves performance by 15-20%. When `busy.c` is running, the throughput rougly drops by half.

For latency, we see the opposite of our expectations. COOP_TASKRUN gives better latency even with `busy.c` running. 

## Conclusion

An experiment with `busy.c` is not the right way to go. The IPI is not sent when that process is not currently running (see kick_process). 

## Investigation of lower latencies with COOP

What we know: the completion of io_uring events is done in co called "task_work" units. These are callbacks attached to processes, and they run whenever that process enters or leaves the kernel. Sending an IPI will kick a process into the kernel, thus completing the event immediately. Without an IPI, the delay of completions depends on how soon the process goes into the kernel (for some other reason). 

More things we know:

 - When io_uring_enter is called to submit events, a task_work might be triggered for an earlier event (if an IPI did not trigger it). We don't know if this actually happens often.
 - The IPI / kick_process does nothing if the process is not currently running on the remote CPU. e.g. if `busy.c` is the running process.

What we need to investigate:

 - In our experiments: when is the task_work being run, e.g. what syscall triggered it. then we can understand why they were handled seemingly as fast as with IPIs in our experiments
 - In what scenario can we actually get worse latencies with COOP?

### Investigation

First, what callback is being used for task work? Run fio with this eBPF script:

```c
kprobe:task_work_add { @[ksym(((struct callback_head*)arg1)->func)] = count(); }
```

We get the result 

```
@[task_numa_work]: 58
@[____fput]: 1291
@[tctx_task_work]: 9779140
```

So the callback that completes io_uring events is `tctx_task_work`.

Now let's see a count of stacktraces for this function, full results in [kstack_tctx_task_work.txt](./kstack_tctx_task_work.txt). The eBPF program is:

```
kprobe:tctx_task_work { @[kstack] = count(); }
```

We get the following results:

```
exc_page_fault+135: 30785
sysvec_reschedule_ipi+133: 1931395
do_syscall_64+105: 8752655
```

So there are two events that trigger our completion task_works:

 - `do_syscall`: any syscall called from our process, probably io_uring_enter but we should verify
 - `sysvec_reschedule_ipi`: the IPIs from kick_process

Interesting that IPIs are mostly not triggering the task_work, but just syscalls. Let's see if we run with the COOP flag. Full results in [kstack_tctx_task_work_coop.txt](./kstack_tctx_task_work_coop.txt).

```
exc_page_fault+135: 18832
do_syscall_64+105: 11661199
```

We see that with the COOP flag, there are no IPIs to trigger task_work.

## io_uring timeline thoughts

Need to think about the io_uring timeline, for traditional use (no polling) I can see three different timelines when using the IPI mechanism:

 - IPI comes in before process wants result, the CQE will be in the CQ when it is needed, process will get it from a peek and does not do a GETEVENTS io_uring_enter call.
 - Process wants a CQ but sees nothing from a peek, does io_uring_enter and immediately there is a task_work to run. This means IPI was in flight but hadn't reached the core, should be a rare event.
 - io_uring_enter GETEVENTS is called but nothing to do, process goes to sleep and is woken up when it has an event, no IPI is sent if process it not current.

When IPIs are not used (COOP flag), there are also three timelines:

 - task_work is added before process wants result, some other syscall may (but may not) cause it to be run, and then process only needs to peek to get the CQE.
 - process wants event, calls GETEVENTS and immediately gets task_work and returns
 - process wants event, calls GETEVENTS but no task_work there yet, goes to sleep

To understand:

 - GETEVENTS function, does it run task_work and return? or does it sleep for short time?
 - When GETEVENTS makes it go to sleep, how and who wakes it up?
