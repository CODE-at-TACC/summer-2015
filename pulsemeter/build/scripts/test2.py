#!/usr/bin/env python

import RPi.GPIO as GPIO
import spidev
import time
import sys
import os
from datetime import datetime
import matplotlib.pyplot as plt
import pylab
import numpy as np

# Function to read SPI data from MCP3008 chip
# channel must be an integer from 0-7
def ReadChannel(channel):
    adc = spi.xfer2([1,(8+channel)<<4,0])
    data = ((adc[1]&3) << 8) + adc[2]
    return data

# Function to convert data to voltage level,
# rounded to specified nmber of decimal places
def ConvertVolts(data,places):
    volts = (data * 3.3) / float(1023)
    volts = (volts * -1) + 3.3
    volts = round(volts,places)
    return(volts)

def TimePoint(start):
    now = datetime.now()
    delta = now - start
    num = delta.seconds*1000 + delta.microseconds/1000
    return(num)

def MovingAverage(interval,windowSize):
    window=np.ones(int(windowSize))/float(windowSize)
    return(np.convolve(interval,window,'same'))

def GetSlope(smoothedData):
    slope=[]
    first=True
    lastValue=0
    for y in smoothedData:
        if first:
            first=False
            slope.append(0)
            lastValue=y
        else:
            slope.append(y-lastValue)
            lastValue=y
    return(slope)

def DetectPeaks(data,slope,totalTime):
    threshold=(max(data)-min(data))*0.50
    peaks=[0]*len(data)
    numPeaks=0
    for i in range(len(data)-1):
        if slope[i] > 0 and slope[i+1] <= 0 and data[i] > threshold:
            peaks[i]=data[i]
            numPeaks += 1
    print "Detected " + str(numPeaks) + " peaks"
    print "Calculated pulse rate is " + str(numPeaks*60/(totalTime/1000)) + " beats per minute"
    return(peaks)

if __name__ == '__main__':
    try:
        
        # set constants
        pulseIndicator=20   # GPIO pin of the LED that blinks with each pulse
        red=26              # GPIO pin of the red LED that is our light source
        delay = 0.005       # delay between light measurements
        channel = 0         # The channel on the A2D converter we are using
        numSamples=2000     # How many samples to collect before stopping
        windowSize=20       # When smoothing the data, the # of samples to use

        # open SPI bus
        spi = spidev.SpiDev()
        spi.open(0,0)

        # setup GPIO
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(pulseIndicator, GPIO.OUT)
        GPIO.setup(red, GPIO.OUT)
        
        data=[]
        timeStamp=[]

        GPIO.output(red,1)
        GPIO.output(pulseIndicator,1)
        print "Collecting Data..."        
        startTime = datetime.now()
        minLevel=3.3
        maxLevel=0.0
        for i in range(numSamples):
            light_level = ReadChannel(channel)
            light_volts = ConvertVolts(light_level,3)
            data.append(light_volts)
            timeStamp.append(TimePoint(startTime))
            if light_volts < minLevel:
                minLevel=light_volts
            if light_volts > maxLevel:
                maxLevel=light_volts
            if light_volts < ((maxLevel+minLevel)/2.0):
                GPIO.output(pulseIndicator,0)
            else:
                GPIO.output(pulseIndicator,1)
            time.sleep(delay)
        
        print "Done"
        GPIO.output(red,0)
        GPIO.output(pulseIndicator,0)
        print "Minimum data value is " + str(min(data))
        data = [x - min(data) for x in data] #set minimum to 0
        dataSmoothed=MovingAverage(data,windowSize)
        slope = GetSlope(dataSmoothed)
        slopeSmoothed=MovingAverage(slope,windowSize)
        totalTime=timeStamp[-1]-timeStamp[0]
        peaks = DetectPeaks(dataSmoothed,slopeSmoothed,totalTime)
        fig=plt.figure()
        plt.scatter(timeStamp,data)
        plt.plot(timeStamp,dataSmoothed,"b")
        plt.plot(timeStamp,slopeSmoothed,"g")
        plt.plot(timeStamp,peaks,"r.")
        plt.show()

    except KeyboardInterrupt:
        spi.close()
        plt.close()
        sys.exit()
