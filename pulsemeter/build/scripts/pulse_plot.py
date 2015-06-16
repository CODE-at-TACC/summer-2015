#!/usr/bin/env python

import RPi.GPIO as GPIO
import spidev
import time
import sys
import os
import numpy as np
import matplotlib
matplotlib.use('TKAgg')
import matplotlib.pyplot as plt
import matplotlib.animation as animation

class voltReader:
	def __init__(self, channel=0, red=26):
		self.red=red	# GPIO pin of the red LED that is our light source
		GPIO.setup(red, GPIO.OUT)
		GPIO.output(red,1)
		self.channel = channel
	def _readChannel(self):
		adc = spi.xfer2([1,(8+self.channel)<<4,0])
		data = ((adc[1]&3) << 8) + adc[2]
		return data
	def _convertVolts(self, level, places):
		volts = level*3.3/1023.0
		volts = volts*-1.0+3.3
		return round(volts,places)
	def getVolts(self):
		level = self._ReadChannel()
		volts = self._convertVolts(level, 3)
		return volts

def DetectPeaks(data):
	slopes = np.diff(data)
	signs = np.sign(slopes)
	return np.sum(np.abs(signs[:-1]- signs[1:]) == 2)

class rtPlot:
	def __init__(self, seconds=10, windowSize=10, pulseLED=20):
		self.xlim = seconds
		self.fig = plt.figure()
		self.ax = plt.axes(xlim=(0,seconds), ylim=(0,3.3))
		self.ax.set_ylabel("Voltage")
		self.ax.set_xlabel("Seconds Elapsed")
		self.line, = self.ax.plot([],[])
		self.x = np.array([])
		self.y = np.array([])
		self.window = np.ones(windowSize)/float(windowSize)
		self.pulseLED = pulseLED #GPIO pin of LED that blinks for each pulse
		GPIO.setup(pulseLED, GPIO.OUT)
		self.vr = voltReader()
	def initPlot(self):
		self.line.set_data([],[])
		return self.line,
	def smoothedY(self, windowSize=50):
		return np.convolve(self.window, self.y,'same')
	def blinkInd(self):
		if self.y[-1] > (np.min(self.y)+np.max(self.y))/2.0:
			GPIO.output(self.pulseLED,1)
		else:
			GPIO.output(self.pulseLED,0)
	def updatePlot(self,i):
		curTime = time.time()
		self.x = np.append(self.x, [curTime])
		self.y = np.append(self.y, [self.vr.getVolts()])
		whereOver = np.where(curTime-self.x > self.xlim)[0]
		if np.any(whereOver):
			minOver = whereOver[0]
			self.x = self.x[minOver:]
			self.y = self.y[minOver:]
		self.blinkInd()
		if len(self.x) > len(self.window):
			self.line.set_data(curTime-self.x, self.smoothedY())
		else:
			self.line.set_data(curTime-self.x, self.y)
		return self.line

if __name__ == "__main__":
	try:
		# open SPI bus
		spi = spidev.SpiDev()
		spi.open(0,0)
		# setup GPIO
		GPIO.setmode(GPIO.BCM)
		rtp = rtPlot()
		# start animation
		ani = animation.FuncAnimation(rtp.fig, rtp.updatePlot, init_func=rtp.initPlot, interval=1)
		plt.show()
	except KeyboardInterrupt:
		spi.close()
		plt.close()
		sys.exit()
