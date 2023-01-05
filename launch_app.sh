#! /usr/bin/env bash

# NAME: launch_app.sh
#
# BRIEF: This script installs packages needed in the environment to run the
# See Stuff application and then runs it locally.
#
# AUTHOR: Kim Lew

set -e

# APP_DIR="/home/ubuntu/rails_see_stuff" # This is root of AWS EC2 instance.
APP_DIR="/opt/rails_see_stuff" # This is root of Docker container.

check_current_directory () {
  if [[ ! -d '../rails_see_stuff' ]]; then
    echo 'You must be in the directory, rails_see_stuff, after cloning the code'
    echo 'with: git clone -b see-stuff-in-docker git@github.com:kimlew/rails_see_stuff.git'
    exit 1
  fi
}

cd "${APP_DIR}"
check_current_directory
echo

echo "RUNNING rails commands and starting the app..."
# Create the new db, load the schema, & seed the db.
# rake db:drop
# rake db:create
rails db:migrate RAILS_ENV=development
rails db:seed
echo

rails server -b 0.0.0.0
# See web app in browser:
# - locally with Docker Compose (port forwarded 3000 in container to 48017): <http://localhost:48017/>
# - on web host with AWS EC2 instance, at IP address, e.g., https://54.190.12.61/
