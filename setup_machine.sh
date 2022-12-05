#! /bin/bash

# Script name: setup_machine.sh

# Description: This script sets up the web server on the Deployment Machine/AWS,
# i.e., shell script sets up EC2 instance for deployment of web app on AWS to run.
# Important: This script is called by main.sh.
# Note: .env created at end of this script.

# Author: Kim Lew

set -ex

ROOT_DIR='/home/ubuntu'
cd "${ROOT_DIR}"
sudo apt update && sudo apt install -y \
  nodejs \
  nano

# Check if nano already installed & install if not. "" or check exit code?
if ! command -v nano &> /dev/null; then
  sudo apt install nano -y
fi

PROJECT_DIR='rails_see_stuff'
if [ -d "${ROOT_DIR}"/"${PROJECT_DIR}" ]; then
  echo "A previous " "${PROJECT_DIR}" "exists. Removing it for a clean start state."
  rm -r "${ROOT_DIR}"/"${PROJECT_DIR}" 
fi

git clone https://github.com/kimlew/rails_see_stuff
echo
echo "CLONED project files from GitHub..."
echo


# TODO: Install Docker & Docker Compose.



# At this point at the end of script, you are passed back to main.sh and onto
# next command with launch_app.sh that launches the See Stuff web app.
