import time
from BrickPi import *  

TIMEOUT=5 # seconds
BAD_RESPONSE=1024
POLL_DELAY=0.01
TACC_DEBUG=0
EV3_COLORNAMES = ['None', 'Black', 'Blue', 'Green', 'Yellow', 'Red', 'White', 'Brown']

def log( message ):
    if TACC_DEBUG == 1:
        print message

def BrickPiWait(duration):
        ot = time.time()
        while (time.time() - ot < duration):
                BrickPiUpdateValues()
                time.sleep(.1)

def Read_Sensor_Robustly(port, default=0, delay=POLL_DELAY):
    if BrickPi.SensorType[port] in range(TYPE_SENSOR_TOUCH,TYPE_SENSOR_COLOR_NONE):
        return Read_NXT_Sensor_Robustly(port, default=0, delay=POLL_DELAY)
    else:
        return Read_EV3_Sensor_Robustly(port, default=0, delay=POLL_DELAY)

def Read_NXT_Sensor_Robustly(port, default=0, delay=0.01):
    BAD_RESPONSE = 256
    response = BAD_RESPONSE
    t1 = time.time()
    t2 = t1
    while (( t2 - t1 ) <= TIMEOUT ) and ( response in [-1, BAD_RESPONSE] ):
        t2 = time.time()
        elapsed = t2 - t1
        result = BrickPiUpdateValues()
        if not result:
            response = BrickPi.Sensor[port]
            if response not in [-1, BAD_RESPONSE]:
                   log( "Elapsed\t" + str(elapsed) + "\tValue\t" + str(response) )
                   return response
        time.sleep( delay )
    log( "Failed\t" + str(TIMEOUT) + "\tValue\t" + str(default) )
    return default

def Read_EV3_Sensor_Robustly(port, default=0, delay=POLL_DELAY):
    response = BAD_RESPONSE
    t1 = time.time()
    t2 = t1
    while (( t2 - t1 ) <= TIMEOUT ) and ( response >= BAD_RESPONSE ):
        result = BrickPiUpdateValues()
        if not result:
            response = BrickPi.Sensor[port]
            t2 = time.time()
            elapsed = t2 - t1
            if ( response < BAD_RESPONSE ):
                log( "Elapsed\t" + str(elapsed) + "\tValue\t" + str(response) )
                return response
            time.sleep( delay )
    log( "Failed\t" + str(TIMEOUT) + "\tValue\t" + str(default) )
    return default

def Read_EV3_Infrared(port, default=0, delay=0.1):
    if BrickPi.SensorType[port] in [TYPE_SENSOR_EV3_INFRARED_M0,TYPE_SENSOR_EV3_INFRARED_M1,TYPE_SENSOR_EV3_INFRARED_M2,TYPE_SENSOR_EV3_INFRARED_M3,TYPE_SENSOR_EV3_INFRARED_M4,TYPE_SENSOR_EV3_INFRARED_M5]:
        return Read_Sensor_Robustly(port, default=0, delay=POLL_DELAY)
    else:
        print "S" + str(port) + " was not configured as an EV3 IR sensor"
        return default

def Read_EV3_Touch(port, default=0, delay=POLL_DELAY):
    if BrickPi.SensorType[port] in [TYPE_SENSOR_EV3_TOUCH_0, TYPE_SENSOR_EV3_TOUCH_DEBOUNCE]:
        # Sample n-fold to get rid of spurious line noise
        samples=5
        measured=0
        for x in range(0, samples):
            touched = Read_Sensor_Robustly(port, default=0, delay=POLL_DELAY)
            measured = measured + touched
        measured = int( round( measured / samples ) )
        return measured
    else:
        print "S" + str(port) + " was not configured as an EV3 touch sensor"
        return default

def Read_EV3_Color(port, default=0, delay=POLL_DELAY):
    if BrickPi.SensorType[port] in [TYPE_SENSOR_LIGHT_OFF, TYPE_SENSOR_EV3_COLOR_M0, TYPE_SENSOR_EV3_COLOR_M1,TYPE_SENSOR_EV3_COLOR_M2,TYPE_SENSOR_EV3_COLOR_M3,TYPE_SENSOR_EV3_COLOR_M4]:
        color_value = Read_Sensor_Robustly(port, default=0, delay=POLL_DELAY)
        if BrickPi.SensorType[port] == TYPE_SENSOR_EV3_COLOR_M2:
            return EV3_COLORNAMES[color_value]
        else:
            return color_value
    else:
        print "S" + str(port) + " was not configured as an EV3 color sensor"
        return default

def Read_NXT_Ultrasonic(port, default=0, delay=POLL_DELAY):
    if BrickPi.SensorType[port] in [TYPE_SENSOR_ULTRASONIC_CONT, TYPE_SENSOR_ULTRASONIC_SS]:
        return Read_Sensor_Robustly(port, default=0, delay=POLL_DELAY)
    else:
        print "S" + str(port) + " was not configured as an NXT Ultrasonic sensor"
        return default

def Read_NXT_Touch(port, default=0, delay=POLL_DELAY):
    if BrickPi.SensorType[port] in [TYPE_SENSOR_TOUCH, TYPE_SENSOR_TOUCH_DEBOUNCE]:
        return Read_Sensor_Robustly(port, default=0, delay=POLL_DELAY)
    else:
        print "S" + str(port) + " was not configured as an NXT touch sensor"
        return default

def Read_NXT_Color(port, default=0, delay=POLL_DELAY):
    if BrickPi.SensorType[port] in [TYPE_SENSOR_COLOR_FULL, TYPE_SENSOR_COLOR_RED, TYPE_SENSOR_COLOR_GREEN, TYPE_SENSOR_COLOR_BLUE, TYPE_SENSOR_COLOR_NONE]:
        # return Read_Sensor_Robustly(port, default=0, delay=POLL_DELAY)
        print "TACC_Pi does not yet support the NXT color sensor"
    else:
        print "S" + str(port) + " was not configured as an NXT color sensor"
        return default
