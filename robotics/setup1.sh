#/bin/bash

cd /home/pi
sudo apt-get -y install netatalk
git clone https://github.com/DexterInd/BrickPi.git
cd BrickPi/Setup\ Files
sudo bash install.sh
echo "Your Pi should be restarting now"
