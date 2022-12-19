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
check_if_rbenv_installed () {
  if ! command -v rbenv > /dev/null; then
    echo "rbenv is NOT installed"
    exit 1
    # echo 'Installing the package manager, rbenv.'
    # sudo apt install -y rbenv
  fi
  echo
  echo "rbenv IS INSTALLED and the system version is: "
  rbenv -v
  echo
  echo "Here is more INFO about rbenv:"
  type rbenv
  echo
}
check_if_ruby_installed () {
  if ! command -v ruby > /dev/null; then
    echo "Ruby is NOT installed"
    exit 1
    # echo 'Installing the package manager, rbenv.'
    # sudo apt install -y rbenv
  fi
  echo
  echo "Ruby IS INSTALLED and the system version is: "
  ruby -v
  echo
}

# RESTART YOUR SHELL - so that these changes take effect.
# shellcheck disable=SC1090,SC1091
eval "$(~/.rbenv/bin/rbenv init - bash)"
echo
echo
echo "CHECKING FOR rbenv & Ruby..."
check_if_rbenv_installed
check_if_ruby_installed

echo "CLONING See Stuff web app from GitHub..."
git clone --depth 1 --branch v2.0 https://github.com/kimlew/rails_see_stuff
cd "${APP_DIR}"
check_current_directory
echo

rbenv global 3.1.2 # Sets system-wide default Ruby version, i.e., tells rbenv what Ruby version to use.
# rbenv local 3.1.2 # Specifies Ruby version for your project & creates .ruby-version file in the current directory.
rbenv rehash
echo
echo "The GLOBAL/system Ruby version used in the project directory is: "
ruby -v
echo

# Install bundler which is required for rails database commands.
echo "INSTALLING bundler..."
echo "gem: --no-document" > ~/.gemrc
sudo gem install rails -v 7 && sudo gem install bundler -v 2.3.22

echo
echo "SHOW Ruby location & PATH. If in SHIMS, might need to add to PATH."
which ruby
echo "$PATH"
echo
echo "CHECK write permissions at stored ruby location to make sure CAN update SHIMS: "
ls -lah /home/ubuntu/.rbenv/shims/ruby
echo
# If you're using rbenv, you must make the rails executable available (by updating the shims) with:
rbenv rehash
bundle install
echo

echo "CHECKING where gems are installed with the home argument with: gem env home"
gem env home
echo
echo "CHECKING the PATH with gem env: "
gem env

echo
echo "SHOW Rails version..."
rails -v
echo

echo "RUNNING rails commands..."
# Create the new db, load the schema, & seed the db.
# rails db:drop
# rails db:create
rails db:migrate RAILS_ENV=development
rails db:seed
echo

# These commands do not need to say ssh to run shell commands on Deployment 
# Machine, e.g. AWS, since main.sh uses the ssh command to call this script.
# Within this script, you are on AWS. Change into the app's directory & run the app.
# TEST ssh with, e.g., ssh -i <full path>/key.pem ec2-user@34.213.67.66
# B4: ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- cd /home/ubuntu/rails_see_stuff \&\& rails server -b 0.0.0.0
echo "LAUNCHING the See Stuff web app..."
echo
rails server -b 0.0.0.0

# View app in browser at:
#  locally: http://localhost:48017
#  after deployed on AWS at IP address, e.g., https://54.190.12.61/
