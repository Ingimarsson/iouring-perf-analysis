import matplotlib as mpl
import matplotlib.pyplot as plt 
import numpy as np
import csv 

mpl.rcParams["font.size"] = 16

setups = ("P-DEF", "P-SYNC", "L-DEF", "L-COOP", "L-SQPOLL", "L-ASYNC")
values = (45.36, 35.12, 44.12, 43.98, 48.68, 38.07)

fig, ax = plt.subplots(layout='constrained')

rects = ax.bar(setups, values, color=['blue', 'orange', 'green', 'red', 'teal', 'brown'])

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('IOPS (x 1000)')

plt.xticks(rotation=-30)

plt.grid(axis='y', which='both', linestyle='--')
plt.savefig('result_iops.svg')
