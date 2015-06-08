#!/usr/bin/env python

import time
from BrickPi import *   								
from TACC_Pi import *

BrickPiSetup()
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_ULTRASONIC_CONT
BrickPiSetupSensors()

while True:
    ultrasonic = Read_NXT_Ultrasonic( PORT_4, 0, 0.01)
    print str(ultrasonic)
    time.sleep(1)

