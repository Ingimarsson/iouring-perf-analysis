import matplotlib.pyplot as plt 
import csv 
  
import matplotlib as mpl
mpl.rcParams["font.size"] = 16

x = [] 
y = [] 

y_label = 'Latency (ms)'
x_label = 'Iteration'

with open('result_fail.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        if idx == 0:
            continue
        x.append(idx) 
        y.append(float(row[0]) / 1000000)

plt.plot(x, y, marker = '.') 

plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

#plt.yscale("log")   
plt.subplots_adjust(left=0.12, right=0.95, bottom=0.18, top=0.95)

plt.grid() 
#plt.show()

plt.savefig('result_coop.svg')
