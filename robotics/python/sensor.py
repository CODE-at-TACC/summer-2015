#!/usr/bin/env python

import time
import random
from BrickPi import *
from TACC_Pi import *

print "Running BrickPiSetup"

BrickPiSetup()  # setup the serial port for communication

BrickPi.SensorType[PORT_1] = TYPE_SENSOR_ULTRASONIC_CONT

print "Running BrickPiSetupSensors"

BrickPiSetupSensors()   #Send the properties of sensors to BrickPi

print "Entering infinite loop"

while True:
    print "Reading value"
    touch_value = Read_NXT_Ultrasonic(PORT_1)
    print ("Port 1: " + str(touch_value))
    time.sleep(0.5)
