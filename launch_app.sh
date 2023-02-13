#! /usr/bin/env bash

# NAME: launch_app.sh
#
# BRIEF: This script installs packages needed in the environment to run the
# See Stuff application and then runs it locally.
#
# AUTHOR: Kim Lew

set -e

check_current_directory () {
  if [[ ! -d '../rails_see_stuff' ]]; then
    echo 'You must be in the directory, rails_see_stuff, after cloning the code'
    echo 'from https://github.com/kimlew/rails_see_stuff'
    exit 1
  fi
}

echo "CLONING See Stuff web app from GitHub..."
# BAD since no Docker & Docker Compose: git clone --depth 1 --branch v2.0 https://github.com/kimlew/rails_see_stuff
# BETTER with Docker & Docker Compose: git clone <this branch>
# BEST & Later: Push image to DockerHub.com & don't need git clone step
cd "${APP_DIR}"
check_current_directory
echo

echo "GLOBAL/system Ruby version is: "
ruby -v
echo

# Install bundler which is required for rails commands for the database & items & rails.
echo "INSTALLING bundler..."
echo "gem: --no-document" > ~/.gemrc
sudo gem install rails -v 7 && sudo gem install bundler -v 2.3.22
echo
echo "SHOW Ruby location & PATH. Should NOT be in SHIMS, since no rbenv."
which ruby
echo "$PATH"
echo
# echo "CHECK write permissions at stored ruby location to make sure CAN update SHIMS: "
# ls -lah /home/ubuntu/.rbenv/shims/ruby
# If you're using rbenv, you must make the rails executable available (by updating the shims) with: rbenv rehash
bundle install

echo "CHECK where gems are installed with the home argument with: gem env home"
gem env home
echo
echo "CHECK the PATH with gem env: "
gem env

echo
echo "SHOW Rails version..."
rails -v
echo

echo "RUNNING rails commands and starting the app..."
# Create the new db, load the schema, & seed the db.
rails db:drop
rails db:create
rails db:migrate RAILS_ENV=development
rails db:seed
echo

rails server -b 0.0.0.0
# See web app in browser:
# - locally with Docker Compose (port forwarded 3000 in container to 48017): <http://localhost:48017/>
# - on web host with AWS EC2 instance, at IP address, e.g., https://54.190.12.61/
