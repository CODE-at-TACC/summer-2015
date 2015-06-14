Creating a Drop-box enabled web cam with Raspberry Pi
=====================================================

## Install fswebcam

```
sudo apt-get update
sudo apt-get install fswebcam
```

## Install Dropbox Uploader

```
git clone https://github.com/andreafabrizi/Dropbox-Uploader/
cp Dropbox-Uploader/dropbox_uploader.sh ~/bin
chmod a+x ~/bin/dropbox_uploader.sh
bin/dropbox_uploader.sh
```

* Follow the directions presented by dropbox_uploader.sh to configure Dropbox

## Create a cam snapshot script

Write the following text out to a file called ~/bin/cam.sh

```bash
#!/bin/bash

# datestamp
DATE=$(date +"%Y-%m-%d_%H%M")
WIDTH=800
HEIGHT=600
DIR=/home/pi/webcam/

# take the photo
mkdir -p ${DIR} && fswebcam -r ${WIDTH}x${HEIGHT} --no-banner ${DIR}/${DATE}.jpg

# upload to Dropbox
~/bin/dropbox_uploader.sh upload ${DIR}/${DATE}.jpg /
```

Make the script executable

```
chmod a+x ~/bin/cam.sh
```

## Additional Resources

* [Raspberry Pi: Using A Standard USB Webcam](https://www.raspberrypi.org/documentation/usage/webcams/)
* [DropBox Uploader](https://github.com/andreafabrizi/Dropbox-Uploader)
