import matplotlib.pyplot as plt 
import csv 
import numpy as np

import matplotlib as mpl
mpl.rcParams["font.size"] = 16

# Plot with / without COOP with CPU intensive task + without (use numbers from exp 5)

x = [] 
y1 = [] 
y2 = [] 

def read_series(file, column):
    y = []

    with open(file,'r') as csvfile: 
        lines = csv.reader(csvfile, delimiter=',') 
        for idx, row in enumerate(lines): 
            print(idx, row)
            if idx > 2:
                y.append(float(row[column])) 

    return y

# 1. plot IOPS
x = list(map(str, map(int, read_series('results.csv', 0))))
y1 = read_series('results.csv', 1)
y2 = read_series('results.csv', 4)
y3 = read_series('results.csv', 7)
y4 = read_series('results.csv', 10)
y5 = read_series('results.csv', 13)
y6 = read_series('results.csv', 16)
y7 = read_series('results.csv', 19)
y8 = read_series('results.csv', 22)

plt.plot(x, y5, marker = 'o',label = "same thread") 
plt.plot(x, y6, marker = 'o',label = "twin thread") 
plt.plot(x, y7, marker = 'o',label = "same NUMA") 
plt.plot(x, y8, marker = 'o',label = "remote NUMA") 
plt.plot(x, y1, marker = 'o',label = "COOP, same thread") 
plt.plot(x, y2, marker = 'o',label = "COOP, twin thread") 
plt.plot(x, y3, marker = 'o',label = "COOP, same NUMA") 
plt.plot(x, y4, marker = 'o',label = "COOP, remote NUMA") 

plt.ylim([0, 300000])
plt.xticks(rotation = 25) 
plt.ylabel("IOPS") 
plt.xlabel("QD") 

#plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_iops.png', bbox_inches='tight')
plt.clf()

# 2. plot IOPS (remote)
x = list(map(str, map(int, read_series('results.csv', 0))))
y1 = read_series('results.csv', 25)
y2 = read_series('results.csv', 28)
y3 = read_series('results.csv', 31)
y4 = read_series('results.csv', 34)
y5 = read_series('results.csv', 37)
y6 = read_series('results.csv', 40)

plt.plot(x, y4, marker = 'o',label = "same thread") 
plt.plot(x, y5, marker = 'o',label = "twin thread") 
plt.plot(x, y6, marker = 'o',label = "same NUMA") 
plt.plot(x, y1, marker = 'o',label = "COOP, same thread") 
plt.plot(x, y2, marker = 'o',label = "COOP, twin thread") 
plt.plot(x, y3, marker = 'o',label = "COOP, same NUMA") 

plt.ylim([0, 300000])
plt.xticks(rotation = 25) 
plt.ylabel("IOPS") 
plt.xlabel("QD") 

#plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_iops_remote.png', bbox_inches='tight')
plt.clf()

# 3. plot bars
x = list(map(str, map(int, read_series('results.csv', 0))))
y1 = read_series('results.csv', 1)
y2 = read_series('results.csv', 4)
y3 = read_series('results.csv', 7)
y4 = read_series('results.csv', 10)
y5 = read_series('results.csv', 13)
y6 = read_series('results.csv', 16)
y7 = read_series('results.csv', 19)
y8 = read_series('results.csv', 22)
y9 = read_series('results.csv', 25)
y10 = read_series('results.csv', 28)
y11 = read_series('results.csv', 31)
y12 = read_series('results.csv', 34)
y13 = read_series('results.csv', 37)
y14 = read_series('results.csv', 40)


setups = ("NUMA 1\nCOOP", "NUMA 1", "NUMA 0\nCOOP", "NUMA 0")
values = {
    'local': [np.average(y1[0]) / 1000, np.average(y5[0]) / 1000, np.average(y9[0]) / 1000, np.average(y12[0]) / 1000],
    'thread': [np.average(y2[0]) / 1000, np.average(y6[0]) / 1000, np.average(y10[0]) / 1000, np.average(y13[0]) / 1000],
    'local NUMA': [np.average(y3[0]) / 1000, np.average(y7[0]) / 1000, np.average(y11[0]) / 1000, np.average(y14[0]) / 1000],
    'remote NUMA': [np.average(y4[0]) / 1000, np.average(y8[0]) / 1000, 0, 0],
}

x = np.arange(len(setups))
width = 0.2
multiplier = 0

fig, ax = plt.subplots(layout='constrained')

for attribute, measurement in values.items():
    offset = width * multiplier
    rects = ax.bar(x + offset, measurement, width, label=attribute)
    #ax.bar_label(rects, padding=3)
    multiplier += 1

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('IOPS (x 1000)')
ax.set_xticks(x + width*1.5, setups)
ax.legend(loc='upper right', ncols=2)
#plt.yscale("log")
ax.set_ylim(0, 180)

plt.grid()
plt.savefig('result_iops_qd_1_bars.svg')
