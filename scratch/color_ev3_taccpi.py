#!/usr/bin/env python

import time
from BrickPi import *   								
from TACC_Pi import *

BrickPiSetup()
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_EV3_COLOR_M2
BrickPiSetupSensors()

while True:
    color = Read_EV3_Color( PORT_4, 0, 0.01)
    print str(color)

