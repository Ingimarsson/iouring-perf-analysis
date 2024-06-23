import re

with open('output_all_cores.txt', 'r') as file:
    data = file.read().rstrip()

    segments = data.split('fio-3.35')[1:]

    for segment in segments:
        iops = re.search("iops.+avg=(\w+\.\w+)", segment)
        p99 = re.search("00th=\[ *(\d+)], 99.50", segment)
        avg = re.search(" lat.+avg=(\w+\.\w+)", segment)

        print(iops.group(1), avg.group(1), p99.group(1))

