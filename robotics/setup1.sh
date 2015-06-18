#/bin/bash

cd /home/pi
sudo apt-get -y install netatalk
git clone https://github.com/DexterInd/BrickPi.git
cd BrickPi/Setup\ Files
echo "This installer will pause for user input while running. Hit <enter> when it gets to the BrickPi setup splash screen, then hit <Y> for next few prompts."
sudo bash install.sh
echo "Your Pi should be restarting now. If it does not, please restart it manually"
