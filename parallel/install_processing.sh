#!/bin/bash

apt-get -y install oracle-java7-jdk
apt-get -y install netatalk
cd /opt
pTar=processing-2.2.1-linux32.tgz
wget http://download.processing.org/$pTar
tar -xzf $pTar && rm $pTar
pFold=${pTar%%-linux*}
cd $pFold && rm -rf java && ln -s /usr/lib/jvm/jdk-7-oracle-armhf java
ln -s /opt/$pFold/processing /usr/local/bin/
