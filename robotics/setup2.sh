#!/bin/bash

cd /home/pi
git clone https://github.com/DexterInd/BrickPi_Python.git
cd BrickPi_Python
sudo python setup.py install
echo "You should be all ready to go!"
