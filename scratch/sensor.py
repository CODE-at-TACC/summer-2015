from BrickPi import *
from BrickPiWrapper import *

BrickPiSetup()

BrickPi.SensorType[PORT_1] = TYPE_SENSOR_ULTRASONIC_CONT

BrickPiSetupSensors()

while True:
	value = BrickPiGetSensor(PORT_1)
	print "Port 1: " + str(value)
	time.sleep(.5)
