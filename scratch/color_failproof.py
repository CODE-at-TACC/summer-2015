#!/usr/bin/env python

import time
from BrickPi import *   								

TIMEOUT = 30
BAD_RESPONSE = 1000

BrickPiSetup()
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_EV3_COLOR_M2
BrickPiSetupSensors()

def Read_Color( port, default):
    response = BAD_RESPONSE
    t1 = time.time()
    t2 = t1
    while (( t2 - t1 ) <= TIMEOUT ) & ( response >= BAD_RESPONSE ):
        result = BrickPiUpdateValues()
        if not result:
            response = BrickPi.Sensor[port]
            t2 = time.time()
            elapsed = t2 - t1
            if (response < BAD_RESPONSE):
                print "Elapsed\t" + str(elapsed) + "\tValue\t" + str(response)
                return response
            time.sleep(0.01)

    print "Failed\t" + str(TIMEOUT) + "\tValue\t" + str(default)
    return default

while True:
    color = Read_Color( PORT_4, 0 )
    #print str(color)

