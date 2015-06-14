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

def waiting():
    print "Waiting"
    BrickPi.Motor[PORT_B] = 0
    BrickPi.Motor[PORT_C] = 0
    BrickPiUpdateValues()
    if touched():
        state = going

def touched():
    if Read_EV3_Touch(PORT_4) == 1:
        print "touched"
        return True
    else:
        return False

def going():
    print "Going"
    BrickPi.Motor[PORT_B] = 255
    BrickPi.Motor[PORT_C] = 255
    BrickPiUpdateValues()
    if hitTheWall():
        state = waiting()

def hitTheWall():
    if Read_NXT_Ultrasonic(PORT_1) < 25:
        print "About to hit the wall!"
        return True
    else:
        return False


state = waiting

while True:
    state()