#!/bin/bash
# This script is used by Terraform as a part of the standard startup script for a Google Compute Engine VM.
# The script takes care of :
#     * Dependency resolution
#     * Single node MATLAB Web App Server installation
#     * MATLAB Runtime installation
#     * Enabling the Google logging agent
# This script is triggered by `main.tf` within the module `wapsnode`.
# This script does not run locally on the user's system.
# This script is accessed from a Google cloud storage bucket by the VM


# Receive Input Arguments

# Bucket containing installation scripts
SCRIPT_BUCKET_NAME=$1

# Bucket containing runtime installers selected by user
RUNTIME_BUCKET_NAME=$2

# Bucket containing MATLAB ISO of selected Release
ISO_BUCKET_NAME=$3

# Release of MATLAB Web App Server selected for deployment
VERSION=$4

# Product License: File Installation Key
FIK=$5

# License Manager within the VPC - IP Address and Port for license checkout
INTERNET=$6
PORT=$7

# Does the user agree to license for installing MATLAB Web App Server and MATLAB Runtime
AGREE_TO_LICENSE=$8

# Installing MATLAB Web App Server dependencies and gcsfuse based on Linux distribution
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/getLinuxDistro.sh . && \
sudo chmod 777 getLinuxDistro.sh && \
sudo ./getLinuxDistro.sh ${SCRIPT_BUCKET_NAME} && \
echo "Completed dependency installation stage." && \

# Create a mount point for attaching a disk
sudo mkdir -p /usr/local/MATLAB && \
sudo chmod -R 775 /usr/local/MATLAB && \

# Mount a persistent disk at /usr/local/MATLAB and format it
sudo lsblk && \
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb && \
sudo mount -o discard,defaults /dev/sdb /usr/local/MATLAB && \
sudo chmod a+w /usr/local/MATLAB && \

# Download required installation scripts from GCS bucket and provide permissions to execute them
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/install-runtime.sh . && \
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/install-waps.sh . && \
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/mount-matlab-iso.sh . && \
sudo chmod 777 install-runtime.sh && \
sudo chmod 777 mount-matlab-iso.sh && \
sudo chmod 777 install-waps.sh && \

# Install MATLAB Runtime 
./install-runtime.sh ${SCRIPT_BUCKET_NAME} ${RUNTIME_BUCKET_NAME} ${AGREE_TO_LICENSE} && \

# Mount GCS bucket with MATLAB ISO
./mount-matlab-iso.sh ${VERSION} ${FIK} ${ISO_BUCKET_NAME} ${AGREE_TO_LICENSE} && \

# Install MATLAB Web App Server
./install-waps.sh ${VERSION} ${INTERNET} ${PORT} && \

# Cleaning up local scripts
sudo rm -rf install-runtime.sh && \
sudo rm -rf mount-matlab-iso.sh && \
sudo rm -rf install-waps.sh && \
sudo rm -rf getLinuxDistro.sh && \
sudo rm -rf install-deps-with-apt.sh && \
sudo rm -rf install-deps-with-yum.sh

# (c) 2022 MathWorks, Inc.
