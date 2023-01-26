#! /usr/bin/env bash

# SCRIPT NAME: launch_app.sh
#
# DESCRIPTION: This script installs packages needed in the environment to run
# the See Stuff app and then runs it locally. The Dockerfile calls this script.
#
# AUTHOR: Kim Lew

set -e

APP_DIR="/opt/rails_see_stuff" # Directory is at the root of Docker container.

cd "${APP_DIR}"
echo
echo "RUNNING rails commands and starting the app..."
# Create the new db, load the schema, & seed the db. Prevent dups with drop & create.
rails db:drop
rails db:create
rails db:migrate RAILS_ENV=development
rails db:seed
echo

rails server -b 0.0.0.0
# See web app in browser:
# - locally with Docker Compose (port forwarded 3000 in container to 48017): <http://localhost:48017/>
# - on web host with AWS EC2 instance, at IP address, e.g., https://54.190.12.61/
