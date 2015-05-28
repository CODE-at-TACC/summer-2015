Getting Started with Raspberry Pi
=================================

---
#### Objectives
1: [Build a tiny computer](01-build.md)
2: [Set it up just so](02-configuring.md)
3: [Explore the Raspbian desktop](03-raspbian-desktop.md)
4: [Learn a little Linux](04-linux-101.md)
---

# Set it up just so

When you first boot up, the system will launch *raspi-config*

!(images/raspi-config.png)

*Hint* You can get back to this screen in the future by typing *sudo raspi-config* in any Terminal window (more on that later)

### Expand the file system

The Raspbian operating system takes up just a small portion of the available disk, but we don't have any idea how big a disk it will be installed on. So, the first time we boot up an SD card we need to let the system know how much room there is for programs and doge pics.

Move the red cursor to *1 Expand Filesystem* using the arrow keys and hit *Return*. You should see a message go by the the filesystem will be enlarged next time you reboot. Simple right?

### Booting to a Graphical Desktop

Some systems launch to a powerful text interface by default because this saves precious memory and processor power. For now, we want to make sure the Raspi starts up in a friendly desktop environment. 
th
Move the red cursor to *3 Enable Boot to Desktop/Scratch*, hit *Return*, and select *Desktop Log in as user 'pi' at the graphical desktop

### Renaming your Pi

Out of the box, all Pis are named 'raspberrypi' on the network. This is going to get confusing, so we want you to give your Pi a unique name. 

Move the cursor to *8 Advanced Options*, hit *Return*, then navigate to *A2 Hostname* and hit *Return* again. Read the message about valid characters, hit *Return*
Enter a new name for your Pi in the box labeled "Please enter a hostname". When you're ready to end, use *Tab* to navigate to the "OK" field and hit *Return*

*Rules of the Road*
1. You can only use the characters a-z, 0-9, and the hyphen
2. All names used in our workshop have to be appropriate for a classroom setting

