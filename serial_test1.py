import numpy as np
import matplotlib.pyplot as plt
import serial

try:
    portx = "COM13"
    bps = 115200
    timout1 = 5
    s1 = serial.Serial(portx, bps, timeout = timout1)
    str1 = s1.read(10).hex()
    print(str1)
    ary1 = np.array(bytearray.fromhex(str1))
    print(ary1)
except Exception as e:
    print("---ERROR---:", e)
