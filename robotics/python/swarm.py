#!/usr/bin/env python

import time
import random
from BrickPi import *                                   
from TACC_Pi import *

BrickPiSetup()  # setup the serial port for communication

BrickPi.MotorEnable[PORT_B] = 1 #Enable the left motor
BrickPi.MotorEnable[PORT_C] = 1 #Enable the right motor
#BrickPi.SensorType[PORT_1] = TYPE_SENSOR_ULTRASONIC_CONT
#BrickPi.SensorType[PORT_4] = TYPE_SENSOR_TOUCH
BrickPiSetupSensors()   #Send the properties of sensors to BrickPi
BrickPi.Timeout = 100   #Set timeout value for the time till which to run the motors after the last command is sent
BrickPiSetTimeout()     #Set the timeout


def forward():
    BrickPi.MotorSpeed[PORT_B] = 255
    BrickPi.MotorSpeed[PORT_C] = 255
    BrickPiUpdateValues()

def turn():
    BrickPi.MotorSpeed[PORT_B] = 255
    BrickPi.MotorSpeed[PORT_C] = -255

def stop():
    BrickPi.MotorSpeed[PORT_B] = 0
    BrickPi.MotorSpeed[PORT_C] = 0
    BrickPiUpdateValues()

while True:
    forward()
    BrickPiWait(5)
    turn()
    BrickPiWait(3)
    stop()
    BrickPiWait(1)
