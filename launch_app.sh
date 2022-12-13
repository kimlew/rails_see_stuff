#! /usr/bin/env bash

# NAME: launch_app.sh
#
# BRIEF: This script installs packages needed in the environment, clones the 
# project repository and then uses rails commands needed to launch the See Stuff
# web application (vs. having it as 1 very long line in the Dockerfile's 
# CMD directive). Then the app, which is deployed on AWS, runs.
#
# AUTHOR: Kim Lew

set -ex

echo "LAUNCHING See Stuff web app..."
echo

APP_DIR=/home/ubuntu/rails_see_stuff

check_current_directory () {
  if [ ! -d "${APP_DIR}" ]; then
    cd "${APP_DIR}"
  fi
}


check_current_directory

echo "CLONING See Stuff web app from GitHub..."
git clone --depth 1 --branch v2.0 https://github.com/kimlew/rails_see_stuff
echo
cd "${APP_DIR}"

# Install bundler which is required for rails database commands.
echo "INSTALLING bundler..."
echo "gem: --no-document" > ~/.gemrc
sudo gem install bundler -v 2.3.22
bundle install

echo "CHECKING where gems are installed with the home argument..."
gem env home
echo

# Create the new db, load the schema, & seed the db.
# rails db:drop
# rails db:create
rails db:migrate RAILS_ENV=development
rails db:seed

# These commands do not need to say ssh to run shell commands on Deployment 
# Machine, e.g. AWS, since main.sh uses the ssh command to call this script.
# Within this script, you are on AWS. Change into the app's directory & run the app.
# TEST ssh with, e.g., ssh -i <full path>/key.pem ec2-user@34.213.67.66
# B4: ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- cd /home/ubuntu/rails_see_stuff \&\& rails server -b 0.0.0.0
echo "RUNNING the See Stuff web app..."
echo
rails server -b 0.0.0.0

# View app in browser at:
#  locally: http://localhost:48017
#  after deployed on AWS at IP address, e.g., https://54.190.12.61/
