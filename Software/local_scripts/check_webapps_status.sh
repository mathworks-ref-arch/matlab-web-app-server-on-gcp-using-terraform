#!/bin/bash

# Inputs for querying webapp server status using gcloud utility
VERSION=$1
WAPS_HOSTNAME=$2
ZONE=$3
ROOT="/usr/local/MATLAB/MATLABWebAppServer/${VERSION}/script"


printf "\n\n\n"
echo -e "\e[1mChecking if Web App Server is up and running.\e[0m"
flag=0
timeout_counter=0
timeout_limit=9

while [ $flag -ne 1 ] && [ $timeout_counter -le $timeout_limit ]
do
    # Test waps status
    status=$(gcloud compute ssh ${WAPS_HOSTNAME} --zone ${ZONE} --command "sudo ${ROOT}/webapps-status" 2>/dev/null)
    
    success_sub_str='Server Status: Running'
    stop_str='Server Status: Stopped'
    if [[ $status = "" ]]; then
        # License Manager is not installed yet
        echo "Still setting up web app server."
        sleep 1m
        # Keep checking for status update
    else
        if [[ "$status" == *"$success_sub_str"* ]]; then
           # Webapp server is installed and status is UP
            echo -e "\e[1mWeb App Server is up and running.\e[0m"
            printf "\n\n"
            echo -e "\e[1m$status\e[0m"
            # Exit if flag is 1
            flag=1
	elif  [[ "$status" == *"$stop_str"* ]]; then
           # Webapp server is installed and service was stopped
            echo -e "\e[1mWeb App Server setup is done but server has been stopped.\e[0m"
            printf "\n\n"
            echo -e "\e[1m$status\e[0m"
            printf "\n\n Attempt to start"
            status=$(gcloud compute ssh ${WAPS_HOSTNAME} --zone ${ZONE} --command "sudo ${ROOT}/webapps-start" 2>/dev/null)
            # Exit if flag is 1
            # flag=1
        else
           # Web App Server is installed but status is not UP
            echo -e "\e[1mWebApp Server status reported.\e[0m"
            printf "\n\n"
            echo -e "\e[1m$status\e[0m"
            # Keep checking for status update
            sleep 30
        fi
    fi
    # Increment time out counter
    timeout_counter=$((timeout_counter+1))
done

if ! [ $timeout_counter -le $timeout_limit ]; then
    printf "\n"
    echo "Health check for deployment has timed out. Check Google Cloud Logs for the Compute instance ${WAPS_HOSTNAME} to find more."
    printf "\n"
fi

# (c) 2022 MathWorks, Inc.
