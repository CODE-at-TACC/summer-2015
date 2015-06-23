#!/usr/bin/env python

print "Importing code libraries..."

import time
import random
from BrickPi import *
from TACC_Pi import *

print "Setting up BrickPi..."

BrickPiSetup()  # setup the serial port for communication
BrickPi.MotorEnable[PORT_B] = 1 #Enable the left motor
BrickPiSetupSensors()   #Send the properties of sensors to BrickPi
BrickPi.Timeout = 100   #Set timeout value for the time till which to run the motors after the last command is sent
BrickPiSetTimeout()     #Set the timeout

print "Starting test... make sure a LEGO motor is attached to Motor Port B."

BrickPi.MotorSpeed[PORT_B] = 255
BrickPiUpdateValues()
BrickPiWait(10)
BrickPi.MotorSpeed[PORT_B] = -255
BrickPiUpdateValues()
BrickPiWait(10)
BrickPi.MotorSpeed[PORT_B] = 0
BrickPiUpdateValues()
BrickPiWait(1)

print "All done. Your motor should have run for 20 seconds, reversing direction in the middle of its run."
