# Experiment 3 (2023-12-03)

4 core experiment (like experiment 2) but run eBPF counters.

## eBPF script

```c
kprobe:native_smp_send_reschedule { @["reschedule"] = count(); } 
kprobe:kick_process { @["kick"] = count(); }
```

## Results

<p>
    <img src="result_kick.png" alt="drawing" width="45%"/>
    <img src="result_reschedule.png" alt="drawing" width="45%"/>
</p>