import matplotlib.pyplot as plt 
import csv 
  
import matplotlib as mpl
mpl.rcParams["font.size"] = 16

x = [] 

y1 = []
y2 = []
y3 = []
y4 = []
y5 = []
y6 = []
y7 = []
y8 = []

a = 3
b = 4
c = 7
d = 8
e = 11
f = 12
g = 15
h = 16

y_label = 'function calls'
x_label = 'Queue Depth'

with open('results_ebpf.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        #if idx == 1:
            #x_label = row[0]
            #y_label = row[a]
        if idx > 1:
            x.append(row[0]) 
            y1.append(float(row[a])) 
            y2.append(float(row[b])) 
            y3.append(float(row[c])) 
            y4.append(float(row[d])) 
            y5.append(float(row[e])) 
            y6.append(float(row[f])) 
            y7.append(float(row[g])) 
            y8.append(float(row[h])) 

plt.plot(x, y1, marker = 'o',label = "off IRQ - false") 
plt.plot(x, y2, marker = 'o',label = "off IRQ - true") 
plt.plot(x, y3, marker = 'o',label = "off IRQ COOP - false") 
plt.plot(x, y4, marker = 'o',label = "off IRQ COOP - true") 
plt.plot(x, y5, marker = 'o',label = "on IRQ - false") 
plt.plot(x, y6, marker = 'o',label = "on IRQ - true") 
plt.plot(x, y7, marker = 'o',label = "on IRQ COOP - false") 
plt.plot(x, y8, marker = 'o',label = "on IRQ COOP - true") 

plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

#plt.yscale("log")   

plt.subplots_adjust(left=0.15, right=0.95, bottom=0.15, top=0.95)

plt.grid() 
plt.legend() 
plt.savefig('result_wake.svg')

