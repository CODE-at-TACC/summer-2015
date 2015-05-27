Lighting an LED using Raspberry Pi
==================================

---
#### Objectives
* Learn about Raspberry Pi pins and ports
* Connect a simple LED circuit to your Raspberry Pi
* Turn your LED on and off using a Python script
---

## Raspberry Pi outputs

## Building a simple LED circuit
Attach the Cobbler to the breadboard
Connect the ribbon cable from the Cobbler to the Pi
Find the 220 Ohm resistor in your kit (red/red/brown/gold)
Wire up the circuit exactly as shown. *Make sure* the LED is in the correct orientation.

## Programming your LED using Python
Open LXTerminal and start the *nano* editor (screenshot)
Copy and paste in the following code

```
#!/bin/env python

import RPi.GPIO as GPIO
import time
# blinking function
def blink(pin):
        GPIO.output(pin,GPIO.HIGH)
        time.sleep(1)
        GPIO.output(pin,GPIO.LOW)
        time.sleep(1)
        return
# to use Raspberry Pi board pin numbers
GPIO.setmode(GPIO.BOARD)
# set up GPIO25 output channel
GPIO.setup(22, GPIO.OUT)
# blink GPIO25 5 times
for i in range(0,5):
        blink(22)
	print 'blink #' + str(i + 1)
GPIO.cleanup() 
```
Save it as *blink.py* (Control O) then quit (Control X)
List your local directory (by typing *ls* in LXterminal) to verify that blink.py was saved in it
Now, let's see if we can start a disco party of blinking lights...
We have to type a few more words into the terminal. In this case, type

```
sudo python blink.py
```

Did it blink? You've taken your first steps towards building this... (Daft Punk animated GIF)

*Note* The word *sudo* means run Python as a "super-user" instead of just plain old "pi". The super-user is the boss of other users on your system. We need to do this because not just anyone is allowed to control the GPIO pins by default.

## Challenges
* Change the number of times the LED flashes
* Update the circuit and code so the LED is controlled by another GPIO pin
* Increase the resistor value to 1000 Ohms - what happens?
* Make the LED flash faster or slower

## Handy references

## Sources
1. http://www.rpiblog.com/2012/09/using-gpio-of-raspberry-pi-to-blink-led.html
