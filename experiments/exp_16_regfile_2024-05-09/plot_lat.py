import matplotlib.pyplot as plt 
import csv 
  
import matplotlib as mpl
mpl.rcParams["font.size"] = 16

x = [] 
y1 = [] 
y2 = [] 

a = 2
b = 5

y_label = 'clat (avg) (us)'
#y_label = 'IOPS (x 1000)'
x_label = 'Queue Depth'

with open('results_busy.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        #if idx == 1:
            #x_label = row[0]
            #y_label = row[a]
        if idx > 1:
            x.append(row[0]) 
            y1.append(float(row[a]) / 1) 
            y2.append(float(row[b]) / 1) 

plt.plot(x, y1, marker = 'o',label = "Registered file") 
plt.plot(x, y2, marker = 'o',label = "Default") 

plt.ylim(0, max(y1)*1.1)
plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

#plt.yscale("log")   
plt.subplots_adjust(left=0.15, right=0.95, bottom=0.15, top=0.95)

plt.grid() 
plt.legend() 
plt.savefig('result_busy_clat_avg.svg')