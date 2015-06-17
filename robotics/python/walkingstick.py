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


while True:
    distance = Read_NXT_Ultrasonic(PORT_1)
    if distance > 100:
        BrickPi.MotorSpeed[PORT_B] = 255
    else:
        BrickPi.MotorSpeed[PORT_B] = 0
    BrickPiUpdateValues()
    time.sleep(0.1)
