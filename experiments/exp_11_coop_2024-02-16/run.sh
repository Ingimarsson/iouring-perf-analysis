#/bin/bash

sleep 5

for name in `ls /sys/class/nvme/nvme2/device/msi_irqs/`; do cat /proc/irq/$name/effective_affinity_list; done | paste -sd " ";

./main /dev/nvme2n1 1 
./main /dev/nvme2n1 1 coop

./main /dev/nvme2n1 2 
./main /dev/nvme2n1 2 coop

./main /dev/nvme2n1 4 
./main /dev/nvme2n1 4 coop

./main /dev/nvme2n1 8 
./main /dev/nvme2n1 8 coop

./main /dev/nvme2n1 16
./main /dev/nvme2n1 16 coop

./main /dev/nvme2n1 32
./main /dev/nvme2n1 32 coop

./main /dev/nvme2n1 64
./main /dev/nvme2n1 64 coop
