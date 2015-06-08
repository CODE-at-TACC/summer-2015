#!/usr/bin/env python

import time
from BrickPi import *   								
from TACC_Pi import *

TIMEOUT = 30
BAD_RESPONSE = 1000

BrickPiSetup()
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_EV3_TOUCH_DEBOUNCE
BrickPiSetupSensors()

while True:
    touch = Read_EV3_Touch( PORT_4, 0, 0.01)
    print str(touch)

