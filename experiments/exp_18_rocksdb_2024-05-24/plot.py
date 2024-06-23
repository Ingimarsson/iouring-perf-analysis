import matplotlib.pyplot as plt 
import numpy as np
import csv 

setups = ("default\nPOSIX", "default\nasync", "liburing\ndefault", "liburing\nCOOP", "liburing\nSQPOLL", "liburing\nASYNC")
values = (1014.6, 1021.5, 1050.74, 1047.18, 940.21, 870.27)

fig, ax = plt.subplots(layout='constrained')

rects = ax.bar(setups, values, color=['blue', 'orange', 'green', 'red', 'teal', 'brown'])

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('Throughput (MB/s)')

plt.grid(axis='y', which='both', linestyle='--')
plt.savefig('result.svg')
