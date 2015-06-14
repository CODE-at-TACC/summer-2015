#!/bin/env python

import RPi.GPIO as GPIO
import time

# Define the blinking function
def blink(pin):
    GPIO.output(pin,GPIO.LOW)
    time.sleep(0.10)
    GPIO.output(pin,GPIO.LOW)
    return

# Use BCM pin numbers
GPIO.setmode(GPIO.BCM)

# Set up a pin for input
GPIO.setup(24, GPIO.IN)
# Set up an output channel to control the LED
GPIO.setup(21, GPIO.OUT)

while True:
    input_state = GPIO.input(18)
    if input_state == True:
        print('Button Pressed')
        blink(25)

