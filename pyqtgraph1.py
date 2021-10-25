import pyqtgraph as pg
import numpy as np
import array

app = pg.mkQApp()   # Build APP
# win = pg.GraphicsWindow()   # Build Window
win = pg.GraphicsLayoutWidget()
win.setWindowTitle('pyqtgraph plot wave')
win.show()
win.resize(800,500)

data = array.array('d') # double type
historyLength = 100 # x length
p = win.addPlot()   # plot p in window
p.showGrid(x=True, y=True)
p.setRange(xRange=[0, historyLength], yRange=[-1.2, 1.2], padding=0)
p.setLabel(axis='left', text='y/V') # left
p.setLabel(axis='bottom', text='x/point')
p.setTitle('y=sin(x)')  # name of chart
curve = p.plot()    # plot a graph
idx = 0
def plotData():
    global idx  # change external variable
    tmp = np.sin(np.pi/50*idx)
    if len(data)<historyLength:
        data.append(tmp)
    else:
        data[:-1] = data[1:]    # move forward
        data[-1] = tmp
    curve.setData(data)
    idx += 1

timer = pg.QtCore.QTimer()
timer.timeout.connect(plotData) # Timer for plotData
timer.start(50)

app.exec()