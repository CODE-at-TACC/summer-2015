# Common Linux Commands

Here are commands for common tasks you will do in Linux. Don't forget, hitting the ```TAB``` will complete directory and file names for you!

## Viewing Diretories

Print your current working directory

```
pwd
```

List files in your current working directory

```
ls
```

List files with extra details

```
ls -al
```

Quickly print the contents of a file called ```program.py```

```
cat program.py
```

## Navigating Directories

Changing directories with ```cd```

Go to the home directory ```/home/pi```

```
cd ~
```

Go to a subdirectory named ```summer-2015```

```
cd summer-2015
```

Go up one directory level

```
cd ..
```

Go directly to a subdirectory called ```summer-2015/robotics/python```

```
cd summer-2015/robotics/python
```

## Editing a File

You will use the Leafpad editor to edit files. 

Open Leafpad:

```
leafpad
```

Open leafpad on a file called ```program.py```

```
leafpad program.py
```

## Using Python

Some scripts are Python scripts and should be run using ```python```. You may stop a running script by pressing ```Ctrl-C``` on your keyboard.

Run a Python script called ```program.py```

```
python program.py
```

Run a Python script called ```program.py``` with superuser access (like when you need to blink and LED)

```
sudo python program.py
```

Edit a python script called ```program.py```

```
leafpad program.py
```

Completely undo changes to a file called ```program.py```

```
git checkout program.py
```

## Using SSH

You will use SSH to connect from your local machine to a remote machine over the network.

Connecting as user ```pi``` to a remote machine at address ```10.0.1.64```

```
ssh pi@10.0.1.64
```

Disconnecting, once you are logged in to a remote machine

```
exit
```

Connecting with X Forwarding (so you can use Leafpad on a remote machine)

```
ssh -X pi@10.0.1.64
```

## Creating, moving and deleting files and directories

Create a text file called ```program.py```

```
leafpad program.py
```

Renaming a file called ```program.py``` to ```program2.py```

```
mv program.py program2.py
```
Making a subdirectory called ```summer-2015```

```
mkdir summer-2015
```

Moving a file called ```program.py``` to a subdirectory called ```summer-2015```

```
mv program.py summer-2015
```

Moving a subdirectory called ```summer-2015``` to your home directory

```
mv summer-2015 ~
```

Removing a file called ```program.py```

```
rm program.py
```

Removing a subdirectory called ```summer-2015```

```
rm -rf summer-2015
```

# Downloading, Installing and Updating

Infrequently, you will need to download, install and update software from the Internet.

## Using git

Git will allow you to download source code from a repository and update it if necessary.

Go to the home directory, then clone the CODE@TACC repository with ```git clone```

```
cd ~
git clone https://github.com/CODE-at-TACC/summer-2015.git
```

Navigate to the ```summer-2015``` repository, then update it with ```git pull```

```
cd ~
cd summer-2015
git pull
```

Completely undo changes to a file called ```program.py```

```
git checkout program.py
```

## Using ```apt-get``` to install software

Updating the list of packages that ```apt-get``` knows about

```
sudo apt-get update
```

Searching the list of packages for games

```
sudo apt-cache search game
```

Install a package called ```nibble```

```
sudo apt-get install nibble
```

Update an installed package called ```nibble```

```
sudo apt-get update nibble
```

Running a script called ```setup1.sh``` in your current working directory

```
./setup1.sh
```

# Configuring Raspbian

Changing your password

```
passwd
```

Clearing authorized SSH keys

```
rm -rf ~/.ssh
```

Entering Raspbian Configuration

```
sudo raspi-config
```

# Modifying File Permissions

## Permissions

Showing ownership and permissions of your current directory

```
ls -al
```
The result is something like this:

```
drwxr-xr-x  12 jychuah  staff   408 Jun 30 14:26 .
drwxr-xr-x   4 jychuah  staff   136 Jun 30 13:44 ..
-rw-r--r--   1 jychuah  staff  3570 Jun 30 14:26 00-command-cheatsheet.md
-rw-r--r--   1 jychuah  staff  3597 Jun 30 14:06 01-build.md
-rw-r--r--   1 jychuah  staff  8804 Jun 30 13:44 02-configuring.md
-rw-r--r--   1 jychuah  staff  3788 Jun 30 13:44 03-raspbian-desktop.md
-rw-r--r--   1 jychuah  staff  7983 Jun 30 13:44 04-linux-101.md
-rw-r--r--   1 jychuah  staff  3525 Jun 30 13:44 05-apt-101.md
-rw-r--r--   1 jychuah  staff  3837 Jun 30 13:44 05-apt-get.md
-rw-r--r--   1 jychuah  staff   943 Jun 30 13:44 10-materials.md
lrwxr-xr-x   1 jychuah  staff    11 Jun 30 13:44 README.md -> 01-build.md
drwxr-xr-x  28 jychuah  staff   952 Jun 30 13:44 images
```

Permission codes:

```d``` File is a directory

```r``` File is readable (worth 4)

```w``` File is writeable (worth 2)

```x``` File is executable (worth 1)

```
rwxr-xr--
```

Means owner readable, writeable, executable, group readable executable, guest readable. The permission code is 754.

## Changing Ownership and Permissions

Change permission code of a file called ```program.py``` to 754

```
chmod 754 program.py
```

Change permission code of every file in a subdirectory called ```summer-2015```

```
chmod -R 754 summer-2015
```

Change ownership of a file called ```program.py``` to the ```pi``` user in the ```pi``` group

```
chown pi:pi program.py
```

Change the ownership of every file in a subdirectory called ```summer-2015``` to the ```pi``` user in the ```pi``` group

```
chown -R pi:pi summer-2015
```

