# Introduction to Processing

https://processing.org/

# Installation

There is no official ARM version of processing available, but luckily it runs
in java, so we can use the jdk 7 available in the raspbian respositories.

```shell
sudo apt-get install oracle-java7-jdk
wget http://download.processing.org/processing-2.2.1-linux32.tgz
tar -xzf processing-2.2.1-linux32.tgz
cd processing-2.2.1
rm -rf java
ln -s /usr/lib/jvm/jdk-7-oracle-armhf java
```
