Raspberry Pi Robotics
=====================

#### Objectives
1. Assemble the BrickPi unit
2. Configure the Raspberry Pi
3. Test the BrickPi system
4. Build your first robot

You will work in teams of at least two (though you can add friends if you like). One team member's Raspberry Pi will act as the embedded brain for various robot inventions. The other Raspberry Pi will act as a control center for programming the one controlling the robots.

## Assemble the BrickPi unit


## Configure the Raspberry Pi

:star: You only need to follow these steps on the Pi unit destined for use in the BrickPi.

### Basic settings

Intro text

* Access **raspi-config** configuration GUI by running the command `sudo raspi-config`
* Under the **8 Advanced Options** set the following
  * SPI **Enable**
  * I2C **Enable**
  * Shell messages on a serial connection **Disable**

### Install the BrickPi software

```shell
cd /home/pi/code-at-tacc/robotics
sudo bash setup1.sh
```

* After this set of commands finishes running, the Pi will restart. When that finishes, open a new Terminal and enter the following commands

```shell
cd /home/pi/code-at-tacc/robotics
sudo bash setup2.sh
```

## Test the BrickPi system
## Build your first robot

#### What you learned
* Assembling a BrickPi unit
* Installing the software dependencies for BrickPi
* Testing whether the assembled BrickPi works
* Building a Simple Robot with BrickPi

## Challenges
* None

## Resources
* [Example SimpleBot #1](https://vimeo.com/130701689)
* [Example SimpleBot #2](https://vimeo.com/130701689)
* [Dexter Industries BrickPi Forums](http://www.dexterindustries.com/forum/?forum=brickpi)
