#!/bin/bash

# This script mounts the GCS bucket containing MATLAB ISO 
# MPS installation will be carried out in a seperate script install-waps.sh

## Setting up required environment variables
WAP_SERVER_ROOT="/usr/local/MATLAB/MATLABWebAppServer"
RUNTIME_ROOT="/usr/local/MATLAB/MATLAB_Runtime"

## Input Variables

# MATLAB Web App Server Release to be deployed
VERSION=$1

# File Installation Key for the licensed product
FIK=$2

# GCS bucket containing MATLAB ISO image
# This input can be provided in 2 formats to this script:
# 1. String: Bucket Name of a valid GCS bucket created by Terraform configuration
# 2. String: gsutil string to the ISO object avaialable within a GCS bucket created before Terraform config is applied.
#   In case 1 the script mounts the bucket directly using GCSfuse
#   In case 2 the script extracts the bucket name from the gsutil string and then mounts the requested ISO 
ISO_BUCKET_NAME=$3

# Does User agree to License before installing MATLAB WEB APP SERVER. by Default this is "no"
AGREE_TO_LICENSE=$4


# If ISO object has been provided instead as a gsutil string, extract the Bucket name as follows
ISO_GSUTIL_URI=$ISO_BUCKET_NAME
ISO_FILE=""

# Extracting bucket name
if [ "${ISO_GSUTIL_URI:0:5}" == "gs://" ]; then
    echo "gsutil URI provided. Need to extract bucketname." && \
    IFS="/" && \
    # Depending on OS one of the following parsing will return empty string
    read -a arr <<< "${ISO_GSUTIL_URI}" || read -a arr <<< ${ISO_GSUTIL_URI} && \
    
    # Override ISO_BUCKET_NAME with extracted bucket name
    ISO_BUCKET_NAME=${arr[2]} && \

    # ISO to be mounted
    ISO_FILE=${arr[-1]} && \
    echo Bucket name extracted is ${ISO_BUCKET_NAME} && \
    echo ISO file that needs to be mounted is ${ISO_FILE}
else
    echo "Bucket name is for a bucket created by this config. No need to extract bucketname from user provided gsutil string."
    ISO_FILE=${VERSION}.iso
fi


# Create a temporary directory for keeping scripts and ISOs
sudo mkdir -p /opt/waps-install && \
sudo chmod -R 777 /opt/waps-install && \

# Configure matlab_installer_input.txt with inputs such as FIK,destinationFolder, agreetoLicense to silently install MATLAB Web App Server
sudo printf "destinationFolder=${WAP_SERVER_ROOT}/${VERSION}\nfileInstallationKey=${FIK}\nagreeToLicense=${AGREE_TO_LICENSE}\nmode=silent" > ~/waps_installer_input.txt && \
sudo mv ~/waps_installer_input.txt /opt/waps-install/waps_installer_input.txt && \

# Mount ISO from bucket to /mnt/iso1 using gcsfuse
sudo mkdir /opt/iso1 && \
sudo mkdir /mnt/iso1 && \
sudo gcsfuse ${ISO_BUCKET_NAME} /mnt/iso1 && \

# Extract the MATLAB ISO to /opt/iso1

sudo mount -o loop /mnt/iso1/${ISO_FILE} /opt/iso1 

# (c) 2022 MathWorks, Inc.
