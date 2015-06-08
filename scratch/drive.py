from BrickPi import *
from BrickPiWrapper import *

BrickPiSetup()

BrickPi.MotorEnable[PORT_B] = 1
BrickPi.MotorEnable[PORT_C] = 1

BrickPiSetupSensors()

BrickPi.MotorSpeed[PORT_B] = 255
BrickPi.MotorSpeed[PORT_C] = 255

BrickPiWait(3)

BrickPi.MotorSpeed[PORT_B] = 0
BrickPi.MotorSpeed[PORT_C] = 0
BrickPiUpdateValues()

BrickPiWait(1)

BrickPi.MotorSpeed[PORT_B] = 255
BrickPi.MotorSpeed[PORT_C] = -255

BrickPiWait(1)

BrickPi.MotorSpeed[PORT_B] = 255
BrickPi.MotorSpeed[PORT_C] = 255

BrickPiWait(2)

BrickPi.MotorSpeed[PORT_B] = 0
BrickPi.MotorSpeed[PORT_C] = 0
