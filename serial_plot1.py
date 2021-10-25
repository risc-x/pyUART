import numpy as np
import matplotlib.pyplot as plt
import serial
datalen = 1000
meanlen = 10
x = np.arange(datalen)
y_temp = np.arange(meanlen)
y = np.ones(datalen)
try:
    portx = "COM13"
    bps = 115200
    timeout1 = 5
    s1 = serial.Serial(portx, bps, timeout = timeout1)
    for i in range(datalen):
        for j in range(meanlen):
            y_temp[j] = int(s1.read(size=1).hex()[:2],16)
        y[i] = np.mean(y_temp)/255*3.3
    s1.close()
    plt.plot(x,y)
    plt.show()
except Exception as e:
    print("---ERROR---:", e)
