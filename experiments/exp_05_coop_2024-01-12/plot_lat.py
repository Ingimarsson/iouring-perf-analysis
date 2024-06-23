import matplotlib.pyplot as plt 
import csv 
  
import matplotlib as mpl
mpl.rcParams["font.size"] = 16

x = [] 
y1 = [] 
y2 = [] 
y3 = []
y4 = []

a = 9
b = 10
c = 11
d = 12

y_label = 'clat (p99) (ms)'
x_label = 'Queue Depth'

with open('results_main.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        #if idx == 1:
            #x_label = row[0]
            #y_label = row[a]
        if idx > 1:
            x.append(row[0]) 
            y1.append(float(row[a])/1000) 
            y2.append(float(row[b])/1000) 
            y3.append(float(row[c])/1000) 
            y4.append(float(row[d])/1000) 

plt.plot(x, y1, marker = 'o',label = "10, 12") 
plt.plot(x, y2, marker = 'o',label = "10, 12, COOP") 
plt.plot(x, y3, marker = 'o',label = "11, 13") 
plt.plot(x, y4, marker = 'o',label = "11, 13, COOP") 

plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

#plt.yscale("log")   

plt.ylim(ymin=0)
plt.subplots_adjust(left=0.15, right=0.95, bottom=0.15, top=0.95)

plt.grid() 
plt.legend(loc='upper left') 
plt.savefig('result_clat_p99.svg')

