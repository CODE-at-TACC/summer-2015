Physical Computing with Raspberry Pi
====================================

#### Objectives
1. [Build a programmable LED light](01-led.md)
2. **[Make your light blink using Python](02-programming.md)**
3. [Add a pushbutton switch to your circuit](03-switch.md)

# Make your light blink and glow using Python

You have made a circuit for the Pi to control, but how do we tell the Pi what to do? :snake:Python to the rescue!

## Find the ```blink.py``` and ```glow.py``` Python scripts

Your ```summer-2015``` repository clone comes with some pre-written Python scripts we will use to make the LED blink and glow. Open up a Terminal and go to  the ```summer-2015/raspi/light``` directory. You can use these commands to do so:

```
cd ~
cd summer-2015/raspi/light
```

Remember - use the tab key instead of typing all the directory names by hand!


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

:sparkle: Try running the ```glow.py``` script

:sparkle: In ```blink.py``` Change the number of times the LED flashes

:sparkle: Make the LED flash faster or slower

:sparkle: Update the circuit and code so the LED is controlled by another GPIO pin

:sparkle: Update the circuit and code to add a second LED controlled by another GPIO pin

:sparkle: Modify your circuit and increase the resistor value to 1000 Ohms (1 kilo-Ohm). Is the light more or less bright than before?


# Resources
* [GPIO Pin Diagram](images/GPIO_Pi2.png)
* [Adafruit Industries Wearables Central](http://www.adafruit.com/category/65)
* [Materials List for "Physical Computing with Raspberry Pi"](10-materials.md#materials-list-introduction-to-physical-computing)


#### Next Objective
1. [x] [Build a programmable LED light](01-led.md)
2. [x] [Make your light blink using Python](02-programming.md)
3. **[Add a pushbutton switch to your circuit](03-switch.md)**
