#!/usr/bin/env python

import RPi.GPIO as GPIO
import spidev
import time
import sys

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

if __name__ == '__main__':
    try:
        
        # set constants
        pulseIndicator=21   # GPIO pin of the LED that blinks with each pulse
        red=26              # GPIO pin of the red LED that is our light source
        delay = 0.25        # delay between light measurements
        channel = 0         # The channel on the A2D converter we are using
        numSamples=40

        # open SPI bus
        spi = spidev.SpiDev()
        spi.open(0,0)

        # setup GPIO
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(pulseIndicator, GPIO.OUT)
        GPIO.setup(red, GPIO.OUT)
        
        GPIO.output(red,1)
        GPIO.output(pulseIndicator,0)
        print "Polling SPI. Voltage values are:"
        for i in range(numSamples):
            light_level = ReadChannel(channel)
            light_volts = ConvertVolts(light_level,3)
            print str(light_volts)
            time.sleep(delay)
        
        print "Done"
        GPIO.output(red,0)
        GPIO.output(pulseIndicator,0)

    except KeyboardInterrupt:
        print "Exiting because Ctrl+C was pressed"

    finally:
        spi.close()
        GPIO.cleanup()
        sys.exit()
