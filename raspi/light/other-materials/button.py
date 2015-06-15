#!/bin/env python

# Bring in some functions from Python libraries
import RPi.GPIO as GPIO
import time

# Set up GPIO to use BCM pin numbers
GPIO.setmode(GPIO.BCM)
# Set up GPIO pin 18 as an INPUT pin
GPIO.setup(18, GPIO.IN)

# Loop over and over
while True:
    # Check the state of pin 18
    input_state = GPIO.input(18)
    # In our circuit, pushing the button
    # makes the pin go to LOW and in Python
    # this means GPIO.input will return False
    # rather than True
    if input_state == False:
        # Print a little message to screen
        # then wait a tiny bit to let the
        # switch re-open after being pushed
        print('Button Pressed')
        time.sleep(0.2)
