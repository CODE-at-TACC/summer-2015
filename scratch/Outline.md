This a freeform listing of topics, notes, etc.

Lesson 01: About the Raspberry Pi

References
Raspberry Pi main page
Adafruit Industries Learn Raspberry Pi

Lesson 02: Assembling and booting your Raspberry Pi
Build
Go through kit contents (annotated photo)
Insert the microSD card
Plug in your keyboard, mouse and HDMI monitor cables
Now plug in the USB power cable to your Pi
Your Raspberry Pi will boot up from the SD card into raspi-config

Configure
In raspi-config we need to change some basic settings. You can get back to this any time.
Expand the filesystem. Only need to do this once!
Set boot behavior
Change the timezone
Rename your raspberry pi (Rules: Has to be safe for the classroom)
Reboot the your Raspberry Pi

Challenges
Run raspi-config after booting. Change the password for the "pi" user (but don't forget to write it down)
Connect to the "Challenge-Mode" network. The password is written on the whiteboard. Don't forget to re-connect to CODE@TACC network

References

Lesson 03: Getting familiar with the Rasperry Pi desktop and command line
Adapted from TACC Linux Basics
Tour of the various menus, icons, etc.
Connect to the Wifi Network
    Network needs to be content-restricted. Easiest thing is to use OpenDNS with restrictive settings. Allow tumblr?
The COMMAND LINE
Launch the Terminal

Challenges

References
Linux cheat sheet
apt guide

Lesson 04: Turning on a light

Raspberry Pi board anatomy
The Cobbler
Overview: Lighting a basic LED
GPIO pins and voltage
LED directionality
Resistors and current
Assemble your circuit
Install Python GPIO
Paste this code into a file and save it. Name it lights.py
Code should blink N times when it is run
sudo python lights.py
Now, walk through the Python code

Challenge
Change the number of times the light blinks
Connect another more LEDs to your Pi. Update the Python code to control it with an additional GPIO pin.

References

Lesson 05: Detecting a button push
