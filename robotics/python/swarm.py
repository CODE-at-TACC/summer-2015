import time
import random
from BrickPi import *
from TACC_Pi import *

BrickPiSetup()  # setup the serial port for communication

BrickPi.MotorEnable[PORT_B] = 1 #Enable the left motor
BrickPi.MotorEnable[PORT_C] = 1 #Enable the right motor
BrickPi.SensorType[PORT_1] = TYPE_SENSOR_ULTRASONIC_CONT
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_TOUCH
BrickPiSetupSensors()   #Send the properties of sensors to BrickPi

timer = 0

def setTimer():
    timer = time.time()

def getTimer():
    return time.time() - timer

def start_moving_forward():
    setTimer()
    state = moving_forward

def moving_forward():
    print "Moving Forward"
    BrickPi.Motor[PORT_B] = 125
    BrickPi.Motor[PORT_C] = 125
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
    setTimer()
    state = turning

def turning():
    print "turning"
    BrickPi.Motor[PORT_B] = 255
    BrickPi.Motor[PORT_C] = -255
    BrickPiUpdateValues()
    if four_seconds_elapsed():
        state = start_moving_forward()

state = start_moving_forward()

while True:
    state()