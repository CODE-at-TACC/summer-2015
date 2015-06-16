#!/usr/bin/env python

import RPi.GPIO as GPIO
import time
import sys

if __name__ == '__main__':
    try:
        
        # set constants
        pulseIndicator=21   # GPIO pin of the LED that blinks with each pulse
        red=26              # GPIO pin of the red LED that is our light source
        delay=0.4
        numSamples=20

        # setup GPIO
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(pulseIndicator, GPIO.OUT)
        GPIO.setup(red, GPIO.OUT)
        
        print "Blinking lights..."
        GPIO.output(red,1)
        GPIO.output(pulseIndicator,0)
        for i in range(numSamples):
            if (i%3 > 0):
                GPIO.output(pulseIndicator,0)
            else:
                GPIO.output(pulseIndicator,1)
            time.sleep(delay)
        
        print "Done"
        GPIO.output(red,0)
        GPIO.output(pulseIndicator,0)

    except KeyboardInterrupt:
        print "Exiting because Ctrl+C was pressed"

    finally:
        GPIO.cleanup()
        sys.exit()
