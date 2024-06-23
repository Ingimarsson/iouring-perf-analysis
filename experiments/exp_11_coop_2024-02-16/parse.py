import re

with open('output_ebpf.txt', 'r') as file:
    data = file.read().rstrip()

    segments = data.split('...')[1:]

    for segment in segments:
        ipi = re.search("reschedule\]: ([0-9]+)", segment)
        kick = re.search("kick\[26\]: ([0-9]+)", segment)
        wake_t = re.search("wake\[0\]: ([0-9]+)", segment)
        wake_f = re.search("wake\[1\]: ([0-9]+)", segment)

        print(ipi.group(1), kick.group(1) if kick else 0, wake_t.group(1) if wake_t else 0, wake_f.group(1) if wake_f else 0)

