import matplotlib.pyplot as plt 
import numpy as np
import csv 
  
import matplotlib as mpl
mpl.rcParams["font.size"] = 16

kick = [] 
reschedule = [] 
cpu1 = []
cpu2 = []

a = 6
b = 7
c = 8
d = 9

x_label = ''
y_label = ''

with open('results_ebpf.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        if idx >= 1:
            kick.append(float(row[a])) 
            reschedule.append(float(row[b])) 
            cpu1.append(float(row[c])) 
            cpu2.append(float(row[d])) 

setups = ("10,12", "10,12\nCOOP", "11,13", "11,13\nCOOP")
values = {
    'kick': kick,
    'reschedule': reschedule,
}

x = np.arange(len(setups))
width = 0.33
multiplier = 0

fig, ax = plt.subplots(layout='constrained')

for attribute, measurement in values.items():
    offset = width * multiplier
    rects = ax.bar(x + offset, measurement, width, label=attribute)
    #ax.bar_label(rects, padding=3)
    multiplier += 1

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('calls / IO')
ax.set_xticks(x + width/2, setups)
ax.legend(loc='upper right', ncols=2)
plt.yscale("log")
ax.set_ylim(0, 8)

plt.grid()
plt.savefig('result_counts.svg')

values = {
    'CPU 11': cpu1,
    'CPU 13': cpu2,
}

x = np.arange(len(setups))
width = 0.33
multiplier = 0

fig, ax = plt.subplots(layout='constrained')

for attribute, measurement in values.items():
    offset = width * multiplier
    rects = ax.bar(x + offset, measurement, width, label=attribute)
    #ax.bar_label(rects, padding=3)
    multiplier += 1

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('IRQs / IO')
ax.set_xticks(x + width/2, setups)
ax.legend(loc='upper right', ncols=2)
ax.set_ylim(0, 0.7)

plt.grid()
plt.savefig('result_irq.svg')

