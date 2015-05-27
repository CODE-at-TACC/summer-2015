#!/bin/env python

import RPi.GPIO as GPIO
import time
# blinking function
def blink(pin):
        GPIO.output(pin,GPIO.HIGH)
        time.sleep(1)
        GPIO.output(pin,GPIO.LOW)
        time.sleep(1)
        return
# to use Raspberry Pi board pin numbers
GPIO.setmode(GPIO.BOARD)
# set up GPIO25 output channel
GPIO.setup(22, GPIO.OUT)
# blink GPIO25 5 times
for i in range(0,5):
        blink(22)
	print 'blink #' + str(i + 1)
GPIO.cleanup() 