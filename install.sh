#!/usr/bin/env bash

# ----------------------------------
# Installs Ubooquity on Raspberry Pi
# ----------------------------------

ROOT_DIR=$PWD
PORT="8082"
FOLDER="/opt/ubooquity"
DAEMON_LOG='/var/log/ubooquity.log'

# ----------------------------------
# Install Java 8
echo "deb https://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src https://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
sudo apt-get update -y
sudo apt-get install oracle-java8-installer -y

# prepare Unzip
sudo apt-get install unzip -y

# prepare Ubooquity folder
sudo mkdir -p ${FOLDER}
cd ${FOLDER}

# Download and install Ubooquity
sudo wget "https://vaemendis.net/ubooquity/service/download.php" -O ubooquity.zip
sudo unzip ubooquity*.zip
sudo rm ubooquity*.zip

sudo chown -R pi:pi ${FOLDER}
sudo mkdir ${FOLDER}/data
sudo chmod -R 755 ${FOLDER}/data

# start Ubooquity
java -jar ${FOLDER}/Ubooquity.jar --remoteadmin --headless --adminport ${PORT} --workdir "${FOLDER}/data"

# copy ubooquity code to /etc/init.d/ubooquity
cd ${ROOT_DIR}

sudo cp ./ubooquity.sh /etc/init.d/ubooquity
sudo chmod +x /etc/init.d/ubooquity
sudo touch ${DAEMON_LOG}


# add to Start script
sudo update-rc.d ubooquity defaults

# Add to crontab manually
# crontab -e
# Add this to the end of file:
#PATH_UBOOQUITY=/opt/ubooquity
#@reboot sleep 180 && cd $PATH_UBOOQUITY && nohup /usr/bin/java -jar $PATH_UBOOQUITY/Ubooquity.jar --remoteadmin --headless --adminport ${PORT} --workdir "${FOLDER}/data"

