#!/bin/bash

# This script carries out the installation for MATLAB Web App Server

## Setting up required environment variables
WAP_SERVER_ROOT="/usr/local/MATLAB/MATLABWebAppServer"
RUNTIME_ROOT="/usr/local/MATLAB/MATLAB_Runtime"

## Input Variables

# MATLAB Web App Server Release to be deployed
VERSION=$1

# License Manager Address and Port hosting license for MATLAB Web App Server
# Most of the time this is within the same VPC
INTERNET=$2
PORT=$3

## Install WebAppServer

sudo /opt/iso1/install -inputFile /opt/waps-install/waps_installer_input.txt && \

## Configure Web App SERVER
sudo mkdir -p /local/MathWorks/webapps/${VERSION} && \
sudo chmod -R 777 /local/MathWorks/webapps && \
sudo chmod -R 777 /local/MathWorks/webapps/${VERSION}  && \
sudo mkdir -p /local/MathWorks/webapps/${VERSION}/apps && \
sudo mkdir -p /local/MathWorks/webapps/${VERSION}/logs && \
sudo mkdir -p /local/MathWorks/webapps/${VERSION}/config && \
sudo chmod -R 777 /local/MathWorks/webapps/${VERSION}/apps && \
sudo chmod -R 777 /local/MathWorks/webapps/${VERSION}/logs && \
sudo chmod -R 777 /local/MathWorks/webapps/${VERSION}/config && \
sudo echo '\n\n\ny' | sudo ${WAP_SERVER_ROOT}/${VERSION}/script/webapps-setup


## Start WAPS and Log
sudo ${WAP_SERVER_ROOT}/${VERSION}/script/webapps-start
sudo ${WAP_SERVER_ROOT}/${VERSION}/script/webapps-config set license ${PORT}@${INTERNET} && \
sudo ${WAP_SERVER_ROOT}/${VERSION}/script/webapps-config set port 9988 && \

#cd /local/MathWorks/webapps/${VERSION} && \
#sudo gcsfuse -o allow_other ${CTF_BUCKET_NAME} apps

# Clean up temporary folders and unmount GCS bucket containing MATLAB Runtime installers

sudo rm -rf /opt/waps-install && \
sudo fusermount -u /opt/iso1 && \
sudo rm -rf /opt/iso1 && \
sudo umount -v /mnt/iso1 && \
sudo rm -rf /mnt/iso1 && \

#Final restart WAPS
sudo ${WAP_SERVER_ROOT}/${VERSION}/script/webapps-restart

# (c) 2022 MathWorks, Inc.