import array
import serial
import threading
import numpy as np
import time
import pyqtgraph as pg


i = 0
def fSerial():
    while(True):
        n = mSerial.inWaiting()
        if(n):
            if 1:
                dat = int.from_bytes(mSerial.readline(1), byteorder='little')
                n = 0
                global i
                if i < historyLength:
                    data[i] = dat
                    i += 1
                else:
                    data[:-1] = data[1:]
                    data[i-1] = dat

def plotData():
    curve.setData(data)

if __name__ == "__main__":
    app = pg.mkQApp()
    win = pg.GraphicsLayoutWidget()
    win.setWindowTitle('pyqtgraph plot wave')
    win.resize(800, 500)
    win.show()
    data = array.array('i')
    historyLength = 200
    a = 0
    data = np.zeros(historyLength).__array__('d')   # fix the length of array
    p = win.addPlot()   # place p in window
    p.showGrid(x=True, y=True) 
    p.setRange(xRange=[0, historyLength], yRange=[0, 255], padding=0)
    p.setLabel(axis='left', text='y/V') # left
    p.setLabel(axis='bottom', text = 'x/Point')
    p.setTitle('semg')  # name of chart
    curve = p.plot()    #draw
    curve.setData(data)
    mSerial = serial.Serial('COM13', 115200, timeout=5)
    if mSerial.isOpen():
        print("open success")
        mSerial.flushInput()
    else:
        print("open failed")
        serial.close()
    th1 = threading.Thread(target=fSerial)
    th1.start()
    timer = pg.QtCore.QTimer()
    timer.timeout.connect(plotData) # Timer refresh data
    timer.start(50) # Every 50 ms
    app.exec()
