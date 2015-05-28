Physical Computing with Raspberry Pi
====================================

#### Objectives
1. [Build a programmable LED light](01-led.md)
2. **[Make your light blink using Python](02-programming.md)**
3. [Add a pushbutton switch to your circuit](03-switch.md)

# Make your light blink using Python

Overview

## Introducing Python

## Create a simple blink program in Python

* Open LXTerminal and start the **nano** text editor by typing `nano` followed by tapping **Return**
* Copy and paste in the following code from a web browser into **nano**

```python
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

# blink GPIO25 10 times
for i in range(0,10):
    blink(22)
    print 'blink #' + str(i + 1)
GPIO.cleanup()
```

![Python code pasted into nano](images/nano.png)

* Save this text to a file named **blink.py** by entering **Cntl-O**, specifying the name of the file. Then, then quit **nano** by entering **Cntl-X**.
* List your local directory (by typing *ls* in LXterminal) to verify that blink.py was saved in it

## Running the program

![Blinken Lights](images/blinken.gif)

We want to start a class-wide disco party of blinking lights. To get there, we have to enter some words into the Terminal: `sudo python blink.py`

**Did your light blink?** If so, you've taken your first steps towards building this...

![Daft Punk Helmet](images/daft.gif)

:star: The word `sudo` means run Python as a **super-user** instead of the regular "pi" user. The super-user is the boss of other users on the system. We need to do this because not just any user is allowed to control the GPIO pins on a Raspberry pi.

# Challenges
* Change the number of times the LED flashes
* Increase the resistor value to 1000 Ohms - what happens?
* Make the LED flash faster or slower
* Update the circuit and code so the LED is controlled by another GPIO pin

# References

# Sources

