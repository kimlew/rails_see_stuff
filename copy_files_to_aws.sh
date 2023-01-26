#! /usr/bin/env bash

# SCRIPT NAME: copy_files_to_aws.sh

# DESCRIPTION: This script is called in main.sh to transfer files needed on the
# the deployment machine on AWS at its root directory for correct set up for 
# the See Stuff web app.

# Note: Web app files & folders are cloned in main.sh from GitHub repo.

# AUTHOR: Kim Lew

set -e

# The IP address and the .pem key are passed in from main.sh.
# AWS and SSH require the .pem key.
PEM_KEY=$1
IP_ADDR=$2

echo "COPYING files from local machine to AWS..."
echo

SRC_DIR_LOCAL='/Users/kimlew/code/ruby3_rails7_sqlite_see_stuff/rails_see_stuff/' # On Mac.
DEST_ON_AWS='/home/ubuntu/' # Path to root directory on deployment machine/AWS.
# Note: /home/ubuntu/ - is root on AWS EC2 instance with Ubuntu 22.04.

# Copy setup files to root directory on AWS.
scp -i "${PEM_KEY}" "${SRC_DIR_LOCAL}"setup_machine.sh ubuntu@"${IP_ADDR}":"${DEST_ON_AWS}"setup_machine.sh
# Since now using the rails-see-stuff image pulled from DockerHub, now:
# - need docker-compose.yml on the AWS EC2 instance - since not using git clone any more
# - do not need to scp launch_app.sh - since that is part of Docker image now
# scp -i "${PEM_KEY}" "${SRC_DIR_LOCAL}"launch_app.sh ubuntu@"${IP_ADDR}":"${DEST_ON_AWS}"launch_app.sh
scp -i "${PEM_KEY}" "${SRC_DIR_LOCAL}"docker-compose.yml ubuntu@"${IP_ADDR}":"${DEST_ON_AWS}"docker-compose.yml
