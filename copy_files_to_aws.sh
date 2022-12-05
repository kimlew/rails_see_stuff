#! /usr/bin/env bash

# Script name: copy_files_to_aws.sh

# Description: This script is called in main.sh to transfer files needed on the
# the deployment machine on AWS at its root directory for correct set up and 
# transfers the project files & folders for the See Stuff web app.

# Note: Web app files & folders are cloned in setup_machine.sh.

# Author: Kim Lew

set -e

# The IP address and the .pem key are passed in from main.sh.
# AWS and SSH require the .pem key.
PEM_KEY=$1
IP_ADDR=$2

echo "COPYING files from local machine to AWS..."
echo

SRC_DIR_LOCAL='/Users/kimlew/code/ruby3_rails7_sqlite_see_stuff/rails_see_stuff/' # On Mac.
DEST_ON_AWS='/home/ubuntu/'  # Path to root directory deployment machine/AWS.

# Copy setup files to root directory on AWS.
scp -i "${PEM_KEY}" "${SRC_DIR_LOCAL}"setup_machine.sh ubuntu@"${IP_ADDR}":"${DEST_ON_AWS}"setup_machine.sh
scp -i "${PEM_KEY}" "${SRC_DIR_LOCAL}"launch_app.sh ubuntu@"${IP_ADDR}":"${DEST_ON_AWS}"launch_app.sh
