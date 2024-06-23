import matplotlib.pyplot as plt 
import csv 
  
x = [] 
y1 = [] 
y2 = [] 

a = 1
b = 6

x_label = 'Queue Depth'
y_label = 'IOPS (x 1000)'

with open('results.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        #if idx == 1:
            #x_label = row[0]
            #y_label = row[a]
        if idx > 1:
            x.append(row[0]) 
            y1.append(float(row[a]) / 1000) 
            y2.append(float(row[b]) / 1000) 
  
plt.plot(x, y1, marker = 'o',label = "Default") 
plt.plot(x, y2, marker = 'o',label = "COOP_TASKRUN") 
  
plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

#plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_iops.svg')

