#!/bin/bash

# This is an example script for setting up MATLAB WebApp Server on Google Cloud Platform.

# Sample Requirements:
        # OS: Ubuntu20
        # Compute: Low, i.e. n2-standard-4 machine
        # Existing Network License Manager on GCP : True
        # Existing GCP VPC & Subnet : True
        # MATLAB WebApp Server Version : R2022a
        # Enable HTTPS : True

## Automate Build and Deploy

## Variables

# Path to service account credentials
Username="gcpUser"
credentials_file_path="/home/gcpUser/credentials.json"
gce_ssh_key_file_path="/home/gcpUser/.ssh/google_compute_engine.pub"
ProjectId="gcpProject"

# MATLAB WebApp Server Version
Version="R2022a"
Agree_To_License="yes"

# File Installation Key for the licensed product
FIK="12345-678912-3456-7890"

# VM Operating system
BootDiskOS="ubuntu20"

# Existing License Manager and Network Details
LicenseManagerHost="10.128.0.2"
VPC_Network_Name="mlm-22a-ubuntu20-licensemanager-network"
Subnet_Name="mlm-22a-ubuntu20-licensemanager-subnetwork"

# Set to true if you wish to create a new subnet within the License Manager VPC
build_subnet_create=false

# If new subnet, then provide subnet_cidr_range
build_subnet_ip_cidr_range="10.130.0.0/20"

# Do you have an existing bucket with ISO
ISO_Bucket_exists=true

# Provide gsutil string for ISO object
ISO_Object_URI="gs://matlab-22a-iso-bucket/R2022a.iso"

# Unique tag for naming resources
TS=$(date +%s) && \
WAPS_BUILD_TAG="waps-${Version:(-3)}-build-${BootDiskOS}-${TS}"

# Initialize and Validate
terraform init 
terraform validate

# Apply Terraform configuration for building MATLAB Web App Server instance
# See ariables.tf to configure other variables
terraform apply -auto-approve -var "credentials_file_path=${credentials_file_path}" \
-var "gce_ssh_key_file_path=${gce_ssh_key_file_path}" \
-var "app_project=${ProjectId}" \
-var "username=${Username}" \
-var "bootDiskOS=${BootDiskOS}" \
-var "LicenseManagerHost=${LicenseManagerHost}" \
-var "vpc_network_name=${VPC_Network_Name}" \
-var "subnet_name=${Subnet_Name}" \
-var "subnet_create=${build_subnet_create}" \
-var "subnet_ip_cidr_range=${build_subnet_ip_cidr_range}" \
-var "tag=${WAPS_BUILD_TAG}" \
-var "Version=${Version}" \
-var "Agree_To_License=${Agree_To_License}" \
-var "FIK=${FIK}" \
-var "ISO_Bucket_exists=${ISO_Bucket_exists}" \
-var "ISO_Object_URI=${ISO_Object_URI}"

# Verify build exit status
build_status=$?
printf "\n\n"

# Proceed only if terraform apply has passed for Build stage with exit code 0.
if [[ $build_status -eq 0 ]]; then
    printf "Finished building Web App Server instance" 
else
     echo -e "\e[1m Failed with status code $build_status. Run 'terraform destroy' to roll back any changes.\e[0m"
fi

# (c) 2022 MathWorks, Inc.
