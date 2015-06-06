# Preparing the Pi

Enter the Raspberry Pi config GUI either from the first boot, or by running the command

```shell
sudo raspi-config
```

In the *Advanced Options* section

* **Enable** SPI
* **Enable** I2C
* **Disable** shell messages on a serial connection

Now reboot the Pi.

# Installing BrickPi

This will walk through the steps to download and install the main BrickPi firmware and libraries.

```shell
git clone https://github.com/DexterInd/BrickPi.git
cd BrickPi/Setup\ Files
sudo bash install.sh
```

After install finishes, the Pi will restart.

# Installing Python Library

```shell
git clone git@github.com:DexterInd/BrickPi_Python.git
cd BrickPi_Python
sudo python setup.py install
```
The BrickPi python libraries are now installed, so you can test out the working code in `Sensor_Examples`. Be aware that the EV3-ColorSensor.py code doesn't actually work. Color sensors should be one of the following classes found in `Sensor_Examples/BrickPi.py`.
```
TYPE_SENSOR_EV3_COLOR_M0 = 50	# Reflected
TYPE_SENSOR_EV3_COLOR_M1 = 51	# Ambient
TYPE_SENSOR_EV3_COLOR_M2 = 52	# Color  // Min is 0, max is 7 (brown)
TYPE_SENSOR_EV3_COLOR_M3 = 53	# Raw reflected
TYPE_SENSOR_EV3_COLOR_M4 = 54	# Raw Color Components
TYPE_SENSOR_EV3_COLOR_M5 = 55	# Calibration???  Not currently implemented.
```
The infrared sensor can be used with one of the following types, and more information can be found at https://github.com/mindboards/ev3dev/wiki/LEGO-EV3-Infrared-Sensor-%2845509%29.
```
TYPE_SENSOR_EV3_INFRARED_M0   = 61	# Proximity, 0 to 100
TYPE_SENSOR_EV3_INFRARED_M1   = 62	# IR Seek, -25 (far left) to 25 (far right)
TYPE_SENSOR_EV3_INFRARED_M2   = 63	# IR Remote Control, 0 - 11
TYPE_SENSOR_EV3_INFRARED_M3   = 64
TYPE_SENSOR_EV3_INFRARED_M4   = 65
TYPE_SENSOR_EV3_INFRARED_M5   = 66
```

# Testing
Motors can be tested and used by plugging a motor into any of the following ports (A-D) and then running the example `BrickPi_Python/Sensor_Examples/LEGO-Motor_Test.py`.

![motor ports](http://www.dexterindustries.com/BrickPi/wp-content/uploads/2013/07/Motor_Ports_Blue-300x208.png)

The infrared sensor can be tested using `BrickPi_Python/Sensor_Examples/EV3-Infrared.py` when the infrared sensor is plugged into S1.

![sensor ports](http://www.dexterindustries.com/BrickPi/wp-content/uploads/2013/07/Sensor_Port_Layout_Yellow-copy-300x208.png)

The color sensor can be tested using the same code after changing
```
BrickPi.SensorType[PORT_1] = TYPE_SENSOR_EV3_INFRARED_M0
```
to one of the color sensor values
```
BrickPi.SensorType[PORT_1] = TYPE_SENSOR_EV3_COLOR_M0
```
I was getting some weird values with the color sensor, so I think it still needs to be reconfigured.
