import matplotlib.pyplot as plt 
import csv 
  
x = [] 
y1 = [] 
y2 = [] 

a = 3
b = 8

x_label = ''
y_label = ''

with open('results.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        if idx == 1:
            x_label = row[0]
            y_label = row[a]
        if idx > 1:
            x.append(row[0]) 
            y1.append(float(row[a])) 
            y2.append(float(row[b])) 
  
plt.plot(x, y1, marker = 'o',label = "Without COOP_TASKRUN") 
plt.plot(x, y2, marker = 'o',label = "With COOP_TASKRUN") 
  
plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

plt.yscale("log")   

plt.grid() 
plt.legend() 
plt.savefig('result_clat_p99.png', bbox_inches='tight')

