import matplotlib.pyplot as plt 
import csv 
  
import matplotlib as mpl
mpl.rcParams["font.size"] = 16

x = [] 
y1 = [] 
y2 = []

y_label = 'Duration - 1e9 IO (s)'
x_label = 'Queue Depth'

with open('result_main.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        if idx < 2:
            continue
        x.append(row[0]) 
        y1.append(float(row[1]))
        y2.append(float(row[2]))

plt.plot(x, y1, marker = 'o',label = "COOP_TASKRUN")
plt.plot(x, y2, marker = 'o',label = "Default")

plt.ylim(0, max(y1)*1.1)

plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

#plt.yscale("log")   

plt.grid() 
plt.legend() 
#plt.show()
plt.subplots_adjust(left=0.12, right=0.95, bottom=0.18, top=0.95)


plt.savefig('result_duration.svg')
