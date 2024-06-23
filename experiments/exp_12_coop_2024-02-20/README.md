# Experiment 10 (2024-02-15)

This experiment is about finding a case where `COOP_TASKRUN` makes things worse. We go off a hint in the man page that it should not be used when completions happen on a different thread from submissions.

## Implementing experiment in fio (failed)

First I tried to modify fio for this experiment. I wanted to have each worker thread spawn an additional thread for it's completions. I also attempted to add a flag `--single-ring` that would share an io_uring with all worker threads, then a completion could happen on a different thread from submission.

I gave up because I could not find a design that would fit fio's architecture. The main problems were:

 1. fio is designed with completions happening (`getevents`) on the same thread, we would need to get the completions back to thread 1 with some IPC
 2. the `getevents` and `event` callbacks are not suitable for multiple threads using the same ring (`--single-ring` idea)

## Implementing a custom benchmark

I wrote a simple io_uring program that does N reads and reports the latency of reach request. It forks a new thread that handles completions on a shared ring. First, I stored the submission time in nanoseconds in the SQE user data field. I ran into the following problem:

 1. the submission thread can submit too many requests, causing a segfault
 2. the clocks on each thread are not accurate to nanoseconds, so the reported latency is wrong

Then I modified the program to a "ping-pong" approach: thread 1 submits on ring 1, then waits for completion on thread 2. thread 2 waits for completions on ring 1 and then submits on ring 2. Then we can measure submission and completion time on the same thread (but it will be the time of 2 requests).

The program is called `io_uring_completion_thread` and is located in /tools/io_uring_completion_thread/.

The program sets the CPU affinity of the two threads to 0 and 1.

## Comparing COOP_TASKRUN on custom benchmark

### Counting kick_process (eBPF)

When comparing our benchmark with/without COOP_TASKRUN, we see no difference. We do eBPF counting like previously, to see what COOP is doing.

|           | kick_process | reschedule |
|-----------|--------------|------------|
| No COOP   | 2635         | 107        |
| With COOP | 1095         | 344        |

Okay, COOP isn't actually doing anything... but why?

### Why is there no kick_process

We know from previous experiments where `kick_process` is called from... when adding task work, a notify method is used...

First we find out what `__set_notify_signal` does: add `TIF_NOTIFY_SIGNAL` to the task if it didn't already have it (`test_and_set_bit()`), and wake up the task if it's in `TASK_INTERRUPTABLE` state (`wake_up_state()`). It returns a boolean, only true if SIGNAL wasn't already set and waking up did not succeed. This is called to deliver task_work if `COOP_TASKRUN` is set.

If `COOP_TASKRUN` is not set, then `set_notify_signal` is called which calls the earlier function, and if it return true (wake up unsuccessful and SIGNAL added for first time) then it also calls `kick_process` to force the delivery of task work. Remember that `kick_process` checks if the process is not on local CPU, and is active, only then is a reschedule IPI sent (we explored this in earlier experiment).

Suspecting `wake_up_state()`, I add eBPF counters for it and run again:


|           | kick_process | reschedule | task_work_add | wake_up_state = false | wake_up_state = true |
|-----------|--------------|------------|---------------|-----------------------|----------------------|
| No COOP   | 2842         | 280        | 2002655       | 242                   | 2000028              |
| With COOP | 2726         | 74         | 2002745       | 63                    | 2000025              |

Indeed, the `wake_up_state` is always returning true, meaning it is actually waking up the task from an INTERRUPTABLE state. The kick / reschedule IPI mechanism is only used to notify running tasks.

This also lead me to experiment with different queue depths in fio. I ran an informal experiment with 10 second runs and eBPF counting:

| QD | kick    | reschedule | wake_up_state = false | wake_up_state = true | IOs submitted |
|----|---------|------------|-----------------------|----------------------|---------------|
| 1  | 959     | 59         | 69                    | 638553               | 629362        |
| 2  | 34254   | 33159      | 33358                 | 603247               | 1186073       |
| 4  | 1761881 | 1760914    | 1760986               | 17608                | 1817399       |
| 8  | 1775159 | 1774205    | 1774260               | 1597                 | 1817872       |
| 16 | 1736506 | 1735571    | 1735600               | 24                   | 1785202       |

Interestingly, with low QD we are sending limited reschedules, because the task was woken up with `wake_up_state` (i.e. it was in the INTERRUPTABLE state). This is a new result: that COOP_TASKRUN makes the most difference at higher QD, and no difference with QD = 1. 

This lead me to redesign the benchmark for higher QD, but also doing a fio experiment to quantify QD effect on COOP_TASKRUN use (experiment 11).

### Adding queue depth to our custom benchmark

I improved the benchmark such that it can run with QD higher than 1. Results were:

 - Like with the fio test above, we now see kick_process, but oddly, no IPIs
 - We see that kick_process is being called on the process CPU, not interrupt CPU
 - Leads us to odd statement in `blk-mq.c`, no HW queues needs to be > 1
 - Loading with 2 queues, we now get IPIs

TODO: measure IPIs as function of QD
TODO: measure run time as function of QD

### Where is tctx_task_work running?

TODO: investigate

### Special case where COOP_TASKRUN breaks things

We have an idea of when COOP could break things: If the submitting thread calls `io_uring_submit` to submit an SQE, and then moves on to pure CPU work that does no system calls. In that case a `kick_process` would be needed to make the submitting thread go into kernel mode and process the outstanding `task_work` that will make the CQE visible to the consuming thread.

We modify our custom benchmark to submit only a single SQE, and then do a long busy loop. We measure the time on the consuming thread that it takes `io_uring_wait_cqe` (liburing) to return the CQE.

Running the benchmark 1000 times, we get the following result:

TODO

We can use eBPF to see how the `task_work` gets run, as the submitting thread does nothing to invoke a kernel mode switch.

```
sudo bpftrace -e 'kprobe:tctx_task_work { @[kstack] = count(); }' -c "./main-fail /dev/nvme2n1 1 coop"
```

Result:

```
@[
    tctx_task_work+1
    get_signal+1104
    arch_do_signal_or_restart+47
    exit_to_user_mode_prepare+245
    irqentry_exit_to_user_mode+9
    irqentry_exit+59
    sysvec_apic_timer_interrupt+102
    asm_sysvec_apic_timer_interrupt+27
]: 1
```

This is the APIC timer interrupt. The kernel uses this interrupt as a "system tick", to invoke the scheduler so no task runs for too long.

Let's count this function over 10 seconds:

```
sudo bpftrace -e 'kprobe:__sysvec_apic_timer_interrupt { @[cpu] = count(); } interval:s:10 { exit(); }' -c './main-fail /dev/nvme2n1 1 coop'
```

Result:

```
...

@[11]: 96
@[37]: 147
@[0]: 2503

```

Indeed, 250 times per second, but less on cores that go into sleep mode. This means that our `task_work` will be delayed at worst by 4 milliseconds, and average 2 milliseconds, which matches with our measurement.

TODO: why is HZ = 100 but this is 250?