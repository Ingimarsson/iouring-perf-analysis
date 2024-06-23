import matplotlib as mpl
import matplotlib.pyplot as plt 
import numpy as np
import csv 

mpl.rcParams["font.size"] = 16

setups = ("P-DEF", "P-SYNC", "L-DEF", "L-COOP", "L-SQPOLL", "L-ASYNC")
values = (218.38, 261.29, 221.86, 223.66, 192.67, 240.95)

fig, ax = plt.subplots(layout='constrained')

rects = ax.bar(setups, values, color=['blue', 'orange', 'green', 'red', 'teal', 'brown'])

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('Latency - P95 (μs)')

plt.xticks(rotation=-30)

plt.grid(axis='y', which='both', linestyle='--')
plt.savefig('result_lat.svg')
