#-*- coding: utf-8 -*-
 
# 串口测试程序
import serial
import matplotlib.pyplot as plt
import numpy as np
import time
import re
 

bytes = 1
 
serialport = serial.Serial("COM13", 115200, timeout=5)
if serialport.isOpen():
	print("open success")
else:
	print("open failed")
 
plt.grid(True) # 添加网格
plt.ion()	# interactive mode
plt.figure(1)
plt.xlabel('times')
plt.ylabel('data')
plt.title('Diagram of UART data by Python')
t = [0]
m = [0]
i = 0
intdata = 0
data = ''
count = 0
 
while True:
	if i > 300:  # 300次数据后，清除画布，重新开始，避免数据量过大导致卡顿。
		t = [0]
		m = [0]
		i = 0
		plt.cla()
	count = serialport.inWaiting()
	if count > 0 :
		if (bytes == 1):
			data = serialport.read(1)
		elif (bytes == 2):
			data = serialport.read(2)
		if data !='':
			intdata = int.from_bytes(data, byteorder='big', signed = False)
			print('%d byte data %d' % (bytes, intdata))
			i = i+1
			t.append(i)
			m.append(intdata)
			plt.plot(t, m, '-r')   
			# plt.scatter(i, intdata)
			plt.draw()
 
	plt.pause(0.002)
