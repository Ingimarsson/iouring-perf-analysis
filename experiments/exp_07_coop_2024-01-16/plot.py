import matplotlib.pyplot as plt 
import csv 

# Plot with / without COOP with CPU intensive task + without (use numbers from exp 5)

x = [] 
y1 = [] 
y2 = [] 
y3 = []
y4 = []

x_label = 'Queue Depth'

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
x = list(map(str, read_series('results.csv', 0)))
y1 = read_series('results.csv', 1)
y2 = read_series('results.csv', 4)
y3 = read_series('../2024-01-12_coop_exp_5/results_main.csv', 1)
y4 = read_series('../2024-01-12_coop_exp_5/results_main.csv', 2)

plt.plot(x, y3, marker = 'o',label = "10, 12") 
plt.plot(x, y4, marker = 'o',label = "10, 12, COOP") 
plt.plot(x, y1, marker = 'o',label = "10, 10, BUSY") 
plt.plot(x, y2, marker = 'o',label = "10, 12, BUSY, COOP") 
  
plt.ylim([0, 550000])
plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel("IOPS") 

#plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_iops.png', bbox_inches='tight')
plt.clf()

# 2. plot avg latency
y1 = read_series('results.csv', 2)
y2 = read_series('results.csv', 5)
y3 = read_series('../2024-01-12_coop_exp_5/results_main.csv', 5)
y4 = read_series('../2024-01-12_coop_exp_5/results_main.csv', 6)

plt.plot(x, y3, marker = 'o',label = "10, 12") 
plt.plot(x, y4, marker = 'o',label = "10, 12, COOP") 
plt.plot(x, y1, marker = 'o',label = "10, 10, BUSY") 
plt.plot(x, y2, marker = 'o',label = "10, 12, BUSY, COOP") 
  
plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel("clat (avg) (us)") 

#plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_clat_avg.png', bbox_inches='tight')
plt.clf()

# 3. plot p99 latency
y1 = read_series('results.csv', 3)
y2 = read_series('results.csv', 6)
y3 = read_series('../2024-01-12_coop_exp_5/results_main.csv', 9)
y4 = read_series('../2024-01-12_coop_exp_5/results_main.csv', 10)

plt.plot(x, y3, marker = 'o',label = "10, 12") 
plt.plot(x, y4, marker = 'o',label = "10, 12, COOP") 
plt.plot(x, y1, marker = 'o',label = "10, 10, BUSY") 
plt.plot(x, y2, marker = 'o',label = "10, 12, BUSY, COOP") 
  
plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel("clat (p99) (us)") 

#plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_clat_p99.png', bbox_inches='tight')