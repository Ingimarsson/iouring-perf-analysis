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

y_label = '# wake_up_state calls'
x_label = 'Queue Depth'

with open('result_main.csv','r') as csvfile: 
    lines = csv.reader(csvfile, delimiter=',') 
    for idx, row in enumerate(lines): 
        print(idx, row)
        if idx < 2:
            continue
        x.append(row[0]) 
        y1.append(float(row[5]))
        y2.append(float(row[6]))
        y3.append(float(row[7]))
        y4.append(float(row[8]))
        y5.append(float(row[9]))
        y6.append(float(row[10]))

plt.plot(x, y3, marker = 'o',label = "state = true")
plt.plot(x, y4, marker = 'o',label = "state = true (COOP)")

plt.plot(x, y5, marker = 'o',label = "state = false")
plt.plot(x, y6, marker = 'o',label = "state = false (COOP)")

plt.ticklabel_format(axis='y', style='sci', scilimits=(4,4))


plt.ylim(0, max(y6)*1.1)

plt.xticks(rotation = 25) 
plt.xlabel(x_label) 
plt.ylabel(y_label) 

#plt.yscale("log")   

plt.grid() 
plt.legend() 
#plt.show()
plt.subplots_adjust(left=0.13, right=0.95, bottom=0.18, top=0.95)

plt.savefig('result_duration_ebpf.svg')
