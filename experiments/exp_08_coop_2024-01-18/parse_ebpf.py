import re

with open('results_ebpf_16_2.txt', 'r') as file:
    data = file.read().replace('\r', '').replace('\n', '')

    segments = data.split('dirty')[1:]

    for segment in segments:
        iops = re.search("nvme2n1: ios=([0-9]*)", segment)
        ipi = re.search("@ipi: ([0-9]*)", segment)
        ipi_um = re.search("sysvec_reschedule.*?: ([0-9]+)", segment)

        print(iops.group(1), ipi.group(1), ipi_um.group(1) if ipi_um else 0)

