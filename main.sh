#! /usr/bin/env bash

# Script name: main.sh

# Description: This script runs all the other scripts required to copy files to 
# deployment machine, i.e., AWS, set up the deployment machine and launch the 
# See Stuff app.
# Create rails_see_stuff on AWS, create directory, deployment_files, copy 
# required files & folders from project directory to deployment_files, scp files & 
# folders from deployment_files to AWS.

# Note: To see meanings of these set flags, type: help set
# set -e  Exits immediately if a command exits with a non-zero status.
# set -x  Prints commands and their arguments as they are executed.

# Author: Kim Lew

set -e

# Prompt user for PEM_KEY and IP_ADDR. Then read in the variables.
read -resp "Type the full path to the .pem key: " PEM_KEY
echo
read -rep "Type the IP address: " IP_ADDR
echo
echo "SETTING UP See Stuff..."
echo

SRC_DIR_LOCAL='/Users/kimlew/code/ruby3_rails7_sqlite_see_stuff/rails_see_stuff/' # On Mac.
DEST_ON_AWS='/home/ubuntu/' # Path to root directory on deployment machine/AWS.

# These lines run on your local computer.
chmod u+x copy_files_to_aws.sh
./copy_files_to_aws.sh "${PEM_KEY}" "${IP_ADDR}"

# These next ssh lines run in a shell on Deployment Machine/AWS.
# TEST ssh with, e.g., ssh -i <full path>/key.pem ec2-user@34.213.67.66
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- chmod u+x setup_machine.sh \&\& \
  ./setup_machine.sh

# CHECK 1: Manually ssh & ls to verify files were copied to AWS.
# CHECK 2: Run these verification lines but UNCOMMENT later: 
echo "Current directory & files copied over are:"
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- pwd
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- ls -laht
echo
echo "Docker & Docker Compose versions installed are:"
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- docker -v
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- docker compose version
echo

# Run docker command to run web app.
# Group nohup command with { } so only that 1 command runs in background.  
# ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- chmod u+x launch_app.sh \&\& \
#   \{ nohup ./launch_app.sh \& \}
echo "Copying Docker & docker-compose.yml to project folder on AWS:"
echo
scp -i "${PEM_KEY}" "${SRC_DIR_LOCAL}"Dockerfile ubuntu@"${IP_ADDR}":"${DEST_ON_AWS}"Dockerfile
scp -i "${PEM_KEY}" "${SRC_DIR_LOCAL}"docker-compose.yml ubuntu@"${IP_ADDR}":"${DEST_ON_AWS}"docker-compose.yml
echo "Running Docker Compose command to start app:"
echo
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- \{ nohup docker compose up --build \& \}
echo "Listing active containers:"
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- docker compose ps
echo
# In a Browser Tab: See the running app at the IP address, e.g., https://54.190.12.61/
