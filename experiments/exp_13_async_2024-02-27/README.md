# Experiment - Async 1

In this experiment we run fio on a single core, with a single NVMe Optane drive, and compare using the `FORCE_ASYNC` flag for different queue depths.

## Performance results

Running a single worker fio task, fixed to core 0.

<p>
    <img src="result_iops.png" alt="drawing" width="30%"/>
    <img src="result_clat_avg.png" alt="drawing" width="30%"/>
    <img src="result_clat_p99.png" alt="drawing" width="30%"/>
</p>

## Without CPU mask 

We still run a single worker fio task, but without fixing it to core 0.

<p>
    <img src="result_all_cores_iops.png" alt="drawing" width="30%"/>
    <img src="result_all_cores_clat_avg.png" alt="drawing" width="30%"/>
    <img src="result_all_cores_clat_p99.png" alt="drawing" width="30%"/>
</p>

## Exploring worker activity with eBPF

                                create      work        
    cpu mask 0                  0           0
    cpu mask 0 + force_async    64          29360383
    no cpu mask                 0           0
    no cpu mask + force async   5178        53682699

