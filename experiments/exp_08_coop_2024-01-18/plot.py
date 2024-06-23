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
            if idx > 1:
                y.append(float(row[column])) 

    return y

# 1. plot IOPS
x = list(map(str, map(int, read_series('results_main_16.csv', 0))))
y1 = np.array(read_series('results_main_16.csv', 1)) / 1000
y2 = np.array(read_series('results_main_16.csv', 4)) / 1000

plt.plot(x, y1, marker = 'o',label = "Default") 
plt.plot(x, y2, marker = 'o',label = "COOP_TASKRUN") 
  
plt.ylim([0, 300])
plt.xticks(rotation = 25) 
plt.ylabel("IOPS (x 1000)") 
plt.xlabel("thinkcycles") 
plt.subplots_adjust(left=0.15, right=0.95, bottom=0.20, top=0.95)
plt.xticks(rotation=45)

#plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_iops.svg')
plt.clf()

# 2. plot avg clat
x = list(map(str, map(int, read_series('results_main_16.csv', 0))))
y1 = read_series('results_main_16.csv', 2)
y2 = read_series('results_main_16.csv', 5)

plt.plot(x, y1, marker = 'o',label = "Default") 
plt.plot(x, y2, marker = 'o',label = "COOP_TASKRUN") 
  
#plt.ylim([0, 300000])
plt.xticks(rotation = 25) 
plt.ylabel("clat (avg) (us)") 
plt.xlabel("thinkcycles") 

plt.yscale("log")   
plt.subplots_adjust(left=0.15, right=0.95, bottom=0.20, top=0.95)
plt.xticks(rotation=45)
plt.ylim(ymin=1, ymax=200000)

plt.grid() 
plt.legend() 
plt.savefig('result_clat_avg.svg')
plt.clf()

# 3. plot p99 clat
x = list(map(str, map(int, read_series('results_main_16.csv', 0))))
y1 = read_series('results_main_16.csv', 3)
y2 = read_series('results_main_16.csv', 6)

plt.plot(x, y1, marker = 'o',label = "Default") 
plt.plot(x, y2, marker = 'o',label = "COOP_TASKRUN") 
  
#plt.ylim([0, 300000])
plt.xticks(rotation = 25) 
plt.ylabel("clat (avg) (p99)") 
plt.xlabel("thinkcycles") 
plt.subplots_adjust(left=0.15, right=0.95, bottom=0.20, top=0.95)
plt.xticks(rotation=45)
plt.ylim(ymin=1, ymax=500000)
plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_clat_p99.svg')
plt.clf()

# 4. plot p99 clat
x = list(map(str, map(int, read_series('results_main_16.csv', 0))))
y1 = list(map(lambda x: (1-x)*100, read_series('results_main_16.csv', 7)))

plt.plot(x, y1, marker = 'o') 
  
#plt.ylim([0, 300000])
plt.subplots_adjust(left=0.15, right=0.95, bottom=0.20, top=0.95)
plt.xticks(rotation=45)
plt.ylabel("IOPS without / with COOP (%)") 
plt.xlabel("thinkcycles") 

#plt.yscale("log")   

plt.grid() 
plt.savefig('result_ratio.svg')
plt.clf()