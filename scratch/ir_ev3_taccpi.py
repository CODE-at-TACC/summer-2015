#!/usr/bin/env python

import time
from BrickPi import *   								
from TACC_Pi import *

BrickPiSetup()
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_EV3_INFRARED_M0
BrickPiSetupSensors()

while True:
    infrared = Read_EV3_Infrared( PORT_4, 0, 0.01)
    print str(infrared)

