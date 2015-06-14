#!/usr/bin/env python

import time
import random
from BrickPi import *
from TACC_Pi import *

BrickPiSetup()  # setup the serial port for communication

BrickPi.SensorType[PORT_1] = TYPE_SENSOR_EV3_TOUCH_DEBOUNCE

BrickPiSetupSensors()   #Send the properties of sensors to BrickPi

while True:
    touch_value = Read_EV3_Touch(PORT_1)
    print ("Port 1: " + str(touch_value))
    time.sleep(0.5)