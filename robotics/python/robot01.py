#!/usr/bin/env python

import time
import random
from BrickPi import *                                   
from TACC_Pi import *

#Move Forward
def fwd():
    print "Forward"
    BrickPi.MotorSpeed[motor1] = speed  
    BrickPi.MotorSpeed[motor2] = speed  
#Move Left
def left():
    print "Left"
    BrickPi.MotorSpeed[motor1] = speed  
    BrickPi.MotorSpeed[motor2] = -speed 
#Move Right
def right():
    print "Right"
    BrickPi.MotorSpeed[motor1] = -speed  
    BrickPi.MotorSpeed[motor2] = speed
#Move backward
def back():
    print "Backward"
    BrickPi.MotorSpeed[motor1] = -speed  
    BrickPi.MotorSpeed[motor2] = -speed
#Stop
def stop():
    print "Stop"
    BrickPi.MotorSpeed[motor1] = 0  
    BrickPi.MotorSpeed[motor2] = 0
# User stop
def user_stop():
    print "User stop"
    stop()

BrickPiSetup()  # setup the serial port for communication

motor1=PORT_B
motor2=PORT_C
BrickPi.MotorEnable[motor1] = 1 #Enable the Motor A
BrickPi.MotorEnable[motor2] = 1 #Enable the Motor B 
BrickPi.SensorType[PORT_1] = TYPE_SENSOR_ULTRASONIC_CONT
BrickPi.SensorType[PORT_4] = TYPE_SENSOR_TOUCH
BrickPiSetupSensors()   #Send the properties of sensors to BrickPi
BrickPi.Timeout=100   #Set timeout value for the time till which to run the motors after the last command is pressed
BrickPiSetTimeout()     #Set the timeout

speed=75   #Set the speed
state=0 # This is the current 'behavior' of the robot

while True:

    # Poll the sensors
    ultrasonic = Read_NXT_Ultrasonic( PORT_1, 0, 0.01)
    touch = Read_NXT_Touch( PORT_4, 0, 0.01)
    #touch = 0

    # front object sensor
    if not state == 5: # state 5 is user_stop
        if ultrasonic > 25:
            state = 1 # no obstacles, move ahead
        elif ultrasonic in range(11,25):
            if state == 1:
                # change direction randomly if moving forward
                state = 2 + random.randint(0,1)
            elif state in range(2,3):
                # keep going the direction we chose to avoid the obstacle
                state = state
        elif ultrasonic in range (1,10):
            state=4 # probably blocked - back up
        elif ultrasonic == 0:
            # Stop if we can't get a reading from the object sensor
            state = 4

    # Rear touch sensor
    if touch == 1:
        if state == 5:
            state = 1 + random.randint(0,2) # move forward in random direction
        else:
            state = 5
 
    # Tell the motors what to do based on "state"
    if state==1:
        fwd()  
    elif state==2 :
        left()
    elif state==3:
        right()
    elif state==4:
        back()
    elif state==0:
        stop()
    elif state==5:
        user_stop()

    BrickPiUpdateValues()
    time.sleep(0.1)

