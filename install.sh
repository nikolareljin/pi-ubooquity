#!/usr/bin/env bash

# ----------------------------------
# Installs Ubooquity on Raspberry Pi
# ----------------------------------

ROOT_DIR=$PWD
PORT="8082"
FOLDER="/opt/ubooquity"

# ----------------------------------
# Install Java 8
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

# prepare Unzip
sudo apt-get install unzip -y

# prepare Ubooquity folder
sudo mkdir -p ${FOLDER}
cd ${FOLDER}

# Download and install Ubooquity
sudo wget "http://vaemendis.net/ubooquity/service/download.php" -O ubooquity.zip
sudo unzip ubooquity*.zip
sudo rm ubooquity*.zip

sudo chown -R pi:pi ${FOLDER}

# start Ubooquity
sudo java -jar ${FOLDER}/Ubooquity.jar -webadmin -headless -port ${PORT}

# copy ubooquity code to /etc/init.d/ubooquity
cd ${ROOT_DIR}

sudo cp ./ubooquity.sh /etc/init.d/ubooquity
sudo chmod +x /etc/init.d/ubooquity

# add to Start script
sudo update-rc.d ubooquity defaults

# Add to Crontab
(crontab -l ; echo "0 * * * * /etc/init.d/ubooquity") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -

# Remove from Crontab
#(crontab -l ; echo "0 * * * * hupChannel.sh") 2>&1 | grep -v "no crontab" | grep -v hupChannel.sh |  sort | uniq | crontab -


# Add to crontab manually
#PATH_UBOOQUITY=/opt/ubooquity
#@reboot sleep 180 && cd $PATH_UBOOQUITY && nohup /usr/bin/java -jar $PATH_UBOOQUITY/Ubooquity.jar -webadmin -headless -port 2022

