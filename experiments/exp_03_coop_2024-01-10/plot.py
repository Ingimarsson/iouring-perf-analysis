import matplotlib.pyplot as plt 
import csv 
  
import matplotlib as mpl
mpl.rcParams["font.size"] = 16

x = [] 
y1 = [] 
y2 = [] 

#a = 4
#b = 9
a = 5
b = 10

x_label = 'Queue Depth'
y_label = ''

with open('results.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        if idx == 1:
            #x_label = row[0]
            y_label = row[a]
        if idx > 1:
            x.append(row[0]) 
            y1.append(float(row[a])) 
            y2.append(float(row[b])) 
  
plt.plot(x, y1, marker = 'o',label = "Default") 
plt.plot(x, y2, marker = 'o',label = "COOP_TASKRUN") 
  
plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

#plt.yscale("log")   

plt.ylim(ymin=0, ymax=3000)
plt.subplots_adjust(left=0.15, right=0.95, bottom=0.15, top=0.95)

plt.grid() 
plt.legend(loc='lower right') 
plt.savefig('result_reschedule.svg')

