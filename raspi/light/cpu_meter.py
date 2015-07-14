#!/bin/env python

import psutil
import RPi.GPIO as GPIO
import time

# blinking function
def blink(pin):
    # Send 3.3V out of the pin    
    GPIO.output(pin,GPIO.HIGH)

    # ### What do you think happens if you modify the number in time.sleep?
    time.sleep(.025)
    # Set the pn to 0V
    GPIO.output(pin,GPIO.LOW)
    time.sleep(.025)
    return
# Use BCM pin numbers
GPIO.setmode(GPIO.BCM)
# Set up GPIO25 output channel
GPIO.setup(25, GPIO.OUT)

# Blink GPIO25 5 times

# ### What do you think happens if you modify the numbers in range(0, 5)?
for i in range(0,500):

    cpu = psutil.cpu_percent(interval=0.1,percpu=False)
    print "cpu: ",cpu
    if cpu > 10:
      blink(25)
      print 'blink #' + str(i + 1)

# Reset all the pins when we are done
GPIO.cleanup()
