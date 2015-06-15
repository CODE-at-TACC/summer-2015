#!/bin/env python

import RPi.GPIO as GPIO
import time

# blinking function
def blink(pin):
    # Send 3.3V out of the pin    
    GPIO.output(pin,GPIO.HIGH)
    time.sleep(1)
    # Set the pin to 0V
    GPIO.output(pin,GPIO.LOW)
    time.sleep(1)
    return

# Use BCM pin numbers
GPIO.setmode(GPIO.BCM)
# Set up GPIO25 output channel
GPIO.setup(25, GPIO.OUT)

# Blink GPIO25 5 times
for i in range(0,5):
    blink(25)
    print 'blink #' + str(i + 1)

# Reset all the pins when we are done
GPIO.cleanup()
