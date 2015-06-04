#!/bin/env python

import RPi.GPIO as GPIO
import time

# Blinking function
def blink(pin):
        GPIO.output(pin,GPIO.HIGH)
        time.sleep(0.10)
	GPIO.output(pin,GPIO.LOW)
        return

# Use BCM pin numbers
GPIO.setmode(GPIO.BCM)

# Set up channel 18 for input
GPIO.setup(18, GPIO.IN)
# Set up GPIO25 output channel
GPIO.setup(25, GPIO.OUT)

while True:
    input_state = GPIO.input(18)
    if input_state == False:
        print('Button Pressed')
        blink(25)

