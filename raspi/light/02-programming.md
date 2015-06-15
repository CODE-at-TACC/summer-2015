Physical Computing with Raspberry Pi
====================================

#### Objectives
1. [Build a programmable LED light](01-led.md)
2. **[Make your light blink using Python](02-programming.md)**
3. [Add a pushbutton switch to your circuit](03-switch.md)

# Make your light blink using Python

You have made a circuit for the Pi to control, but how do we tell the Pi what to do? :snake:Python to the rescue!

## Create a simple blink program in Python

To make sure this works for everyone, we will cut and paste a program instead of typing it all in. Feel free to start with this program in the future when you make your own projects!

* Open LeafPad, then copy and paste the following text into a new file. Save the file as **blink.py** in **/home/pi**

**blink.py**

```python
#!/bin/env python

import RPi.GPIO as GPIO
import time

# blinking function
def blink(pin):
    # Send 3.3V out of the pin    
    GPIO.output(pin,GPIO.HIGH)
    time.sleep(1)
    # Set the pin to 0V
    GPIO.output(pin,GPIO.LOW)
    time.sleep(1)
    return

# Use BCM pin numbers
GPIO.setmode(GPIO.BCM)
# Set up GPIO25 output channel
GPIO.setup(25, GPIO.OUT)

# Blink GPIO25 5 times
for i in range(0,5):
    blink(25)
    print 'blink #' + str(i + 1)

# Reset all the pins when we are done
GPIO.cleanup()
```

* Open a new LXTerminal window so that you can type in the commands to run your new Python program. 
* Before we run the program, let's make sure we know where it is. In the Termina window, list the local directory (by typing *ls* in LXterminal). In the list of files returned, you should see one callled **blink.py**. Let an instructor know if you don't see that file name. 

## Running the blink.py program

![Blinken Lights](images/blinken.gif)

Let's throw a class-wide disco party of blinking lights:

* Enter the following words into the Terminal and keep an eye on your prototyped circuit: `sudo python blink.py`

:star: The word `sudo` means run Python as a **super-user** instead of the regular "pi" user. The super-user is the boss of other users on a Linux system. We need to do this because not just any user is allowed to control the GPIO pins on a Raspberry pi. 

**Did your LED light blink?** If so, you've taken your first steps towards building this...

![Daft Punk Helmet](images/daft.gif)

# What you learned
* How to define Raspberry Pi GPIO pins as outputs
* How to use a function to turn a GPIO pin on and off
* Why we need to preface some commands with **sudo**
* How to reset the GPIO system at the end of a program

# Challenges
:sparkle: Change the number of times the LED flashes

:sparkle: Increase the resistor value to 1000 Ohms (1 kilo-Ohm). Is the light more or less bright than before?

:sparkle: Make the LED flash faster or slower

:sparkle: Update the circuit and code so the LED is controlled by another GPIO pin

:sparkle: Update the circuit and code to add a second LED controlled by another GPIO pin

# Resources
* [GPIO Pin Diagram](images/GPIO_Pi2.png)
* [Adafruit Industries Wearables Central](http://www.adafruit.com/category/65)

#### Next Objective
1. [x] [Build a programmable LED light](01-led.md)
2. [x] [Make your light blink using Python](02-programming.md)
3. **[Add a pushbutton switch to your circuit](03-switch.md)**
