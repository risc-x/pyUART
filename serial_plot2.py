import numpy as np
import matplotlib.pyplot as plt
import serial
datalen = 1000
meanlen = 50
x = np.arange(datalen)
y_temp = np.arange(meanlen)
y = np.ones(datalen)
try:
    portx = "COM13"
    bps = 115200
    timeout1 = 5
    s1 = serial.Serial(portx, bps, timeout = timeout1)
    for i in range(datalen):
        str1 = s1.read(meanlen).hex()
        ary1 = np.array(bytearray.fromhex(str1))
        y[i] = np.mean(ary1)/255*3.3
    s1.close()
    plt.plot(x,y)
    plt.show()
except Exception as e:
    print("---ERROR---:", e)
