import re

with open('results_ebpf.txt', 'r') as file:
    data = file.read().rstrip()

    segments = data.split('fio-3.35')[1:]

    for segment in segments:
        reschedule = re.search("reschedule\]: ([0-9]+)", segment)
        kick = re.search("kick\]: ([0-9]+)", segment)
        wake0 = re.search("wake\[0\]: ([0-9]+)", segment)
        wake1 = re.search("wake\[1\]: ([0-9]+)", segment)

        print(reschedule.group(1) if reschedule else 0, kick.group(1), wake0.group(1), wake1.group(1))

