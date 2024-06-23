import matplotlib.pyplot as plt 
import csv 

import matplotlib as mpl
mpl.rcParams["font.size"] = 16

# Plot with / without COOP with CPU intensive task + without (use numbers from exp 5)

x = [] 
y1 = [] 
y2 = [] 
y3 = []
y4 = []

def read_series(file, column):
    y = []

    with open(file,'r') as csvfile: 
        lines = csv.reader(csvfile, delimiter=',') 
        for idx, row in enumerate(lines): 
            print(idx, row)
            if idx >= 1:
                y.append(float(row[column].strip('%'))) 

    return y

# 1. plot IOPS
x = list(map(str, map(int, read_series('results_ebpf_16.csv', 0))))
y1 = read_series('results_ebpf_16.csv', 4)
y2 = read_series('results_ebpf_16.csv', 5)

plt.plot(x, y1, marker = 'o',label = "IPI per IO") 
plt.plot(x, y2, marker = 'o',label = "IPI from userspace") 
  
plt.ylim([0, 105])
plt.xticks(rotation = 45) 
plt.ylabel("%") 
plt.xlabel("thinkcycles") 
plt.ylim(ymax=140, ymin=-5)
#plt.yscale("log")   
plt.subplots_adjust(left=0.15, right=0.95, bottom=0.20, top=0.95)

plt.grid() 
plt.legend(loc='upper left') 
plt.savefig('result_ebpf.svg')
plt.clf()
