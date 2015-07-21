import time
import random
from BrickPi import *
from TACC_Pi import *

BrickPiSetup()  # setup the serial port for communication


BrickPi.MotorEnable[PORT_B] = 1 #Enable the left motor
BrickPi.MotorEnable[PORT_C] = 1 #Enable the right motor
BrickPi.SensorType[PORT_1] = TYPE_SENSOR_ULTRASONIC_CONT
BrickPi.SensorType[PORT_2] = TYPE_SENSOR_LIGHT_OFF
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_EV3_TOUCH_DEBOUNCE
BrickPiSetupSensors()   #Send the properties of sensors to BrickPi

state = None

def waiting():
    global state
    print "Waiting"
    BrickPi.MotorSpeed[PORT_B] = 0
    BrickPi.MotorSpeed[PORT_C] = 0
    BrickPiUpdateValues()
    if lightson():
        state = going

def lightson():
    if Read_EV3_Color(PORT_2) > 100:
        print "Lights on!"
        return True
    else:
        return False

def going():
    global state
    print "Going"
    BrickPi.MotorSpeed[PORT_B] = 255
    BrickPi.MotorSpeed[PORT_C] = 255
    BrickPiUpdateValues()
    if hitTheWall():
        state = waiting

def hitTheWall():
    if Read_NXT_Touch(PORT_4) == 1:
        print "Hit the wall!"
        return True
    else:
        return False


state = waiting

while True:
    state()
    time.sleep(0.1)
