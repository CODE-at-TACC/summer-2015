Getting Started with Raspberry Pi
=================================

#### Objectives
1. [Build a tiny computer](01-build.md)
2. **[Set it up just so](02-configuring.md)**
3. [Explore the Raspbian desktop](03-raspbian-desktop.md)
4. [Learn a little Linux](04-linux-101.md)

# Set it up just so

When you first boot up, the system will launch **raspi-config**

![Raspberry Pi Software Configuration Tool](images/raspi-config.png)

**Raspi-config** is a text-based application, so you can't use your mouse to navigate. Instead, use the **Arrow** and **Tab** keys to move between fields, **Return** to select, and use **Esc** to cancel. You can always get back to the main page by tapting Esc a couple of times!

:star: You can access this screen in the future to make other changes by typing `sudo raspi-config` in any Terminal window (more on Terminals later...)

### Expand the file system

The Raspbian operating system takes up just a small portion of the available storage space, but we don't start off knowing how big of a disk it was installed on. So, the first time we boot up from a new SD card we need to let the system know how much room there is for programs and doge pics.

* Move the red cursor to **1 Expand Filesystem** using the arrow keys and tap **Return**. You should see a message go by the the filesystem will be enlarged next time you reboot. Simple right?

![Raspberry Doge](images/doge.jpg)

### Booting to a Graphical Desktop

Some systems launch to a powerful text interface by default because this saves precious memory and processor power. For now, we want to make sure the Raspi starts up in a friendly desktop environment.

* Move the red cursor to **3 Enable Boot to Desktop/Scratch**, tap **Return**, and select **Desktop Log in as user 'pi' at the graphical desktop**. tap **Return**.

### Renaming your Pi

Out of the box, all Pis are named **raspberrypi** on the network. This is going to get confusing, so you are going to give your Pi its own unique name.

* Move the cursor to **8 Advanced Options**, tap **Return**, then navigate to **A2 Hostname** and tap **Return** again. Read the message about valid characters, tap **Return** one more time.
* Enter a new name for your Pi in the box labeled "Please enter a hostname". When you're ready to end, use **Tab** to navigate to the **OK** field and tap **Return**

#### Rules of the Road

1. You can only use the characters a-z, 0-9, and the hyphen
2. Try to keep your names short because you and others will have to type them
3. :exclamation: All names used in our workshop have to be appropriate for a classroom setting

### Restarting

Most of the changes you made won't take effect until the computer restarts. So, let's do that now from within **raspi-config**

* Navigate the cursor to **Finish** and tap **Return**, then watch the system restart. It should only take a few seconds. Then, you will be ready to explore the desktop!

![Raspbian Desktop](images/desktop-start.jpg)

** The Raspbian desktop will appear after you reboot from raspi-config**

