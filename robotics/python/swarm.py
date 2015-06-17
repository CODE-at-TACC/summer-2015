import time
import random
from BrickPi import *
from TACC_Pi import *

BrickPiSetup()  # setup the serial port for communication

BrickPi.MotorEnable[PORT_B] = 1 #Enable the left motor
BrickPi.MotorEnable[PORT_C] = 1 #Enable the right motor
BrickPi.SensorType[PORT_1] = TYPE_SENSOR_ULTRASONIC_CONT
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_EV3_TOUCH_DEBOUNCE
BrickPiSetupSensors()   #Send the properties of sensors to BrickPi

timer = 0
state = None

def setTimer():
    global timer
    timer = time.time()

def getTimer():
    global timer
    return time.time() - timer

def start_moving_forward():
    global state
    setTimer()
    state = moving_forward

def moving_forward():
    global state
    print "Moving Forward"
    BrickPi.MotorSpeed[PORT_B] = 125
    BrickPi.MotorSpeed[PORT_C] = 125
    BrickPiUpdateValues()
    if four_seconds_elapsed():
        state = start_turning

def four_seconds_elapsed():
    if getTimer() > 4:
        print "four seconds elapsed"
        return True
    else:
        return False

def start_turning():
    global state
    setTimer()
    state = turning

def turning():
    global state
    print "turning"
    BrickPi.MotorSpeed[PORT_B] = 255
    BrickPi.MotorSpeed[PORT_C] = -255
    BrickPiUpdateValues()
    if four_seconds_elapsed():
        state = start_moving_forward

state = start_moving_forward

while True:
    state()
    time.sleep(0.1)
