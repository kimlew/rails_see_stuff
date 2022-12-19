#! /bin/bash

# Script name: setup_machine.sh

# Description: This script sets up the web server on the Deployment Machine/AWS,
# i.e., shell script sets up EC2 instance for deployment of web app on AWS to run.
# Important: This script is called by main.sh.
# Note: .env created at end of this script.

# Author: Kim Lew

set -ex

ROOT_DIR='/home/ubuntu'
PROJECT_DIR='rails_see_stuff'

check_current_directory () {
  if [ ! -d "${THE_DIR}" ]; then
    cd "${THE_DIR}"
  fi
}

check_existing_project_directory () {
  if [ -d "${ROOT_DIR}"/"${PROJECT_DIR}" ]; then
    echo "A previous " "${PROJECT_DIR}" "exists. Removing it for a clean start state."
    echo 'The directory path is: ' "${ROOT_DIR}"/"${PROJECT_DIR}"
    rm -r "${ROOT_DIR:?}"/"${PROJECT_DIR}"
  fi
}

# Check if nano already installed & install if not. "" or check exit code?
check_if_nano_installed () {
  if ! command -v nano &> /dev/null; then
    sudo apt install nano -y
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
  echo "rbenv IS INSTALLED. rbenv VERSION and INFO about rbenv:"
  rbenv -v
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
  echo "Ruby IS INSTALLED and the version is: "
  ruby -v
  echo
}

check_current_directory "${ROOT_DIR}"
# https://itslinuxfoss.com/install-ruby-ubuntu-22-04/
# git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
# Other site had: libgdbm5 libgdbm-dev
# Replaced libreadline-dev with libreadline6-dev - https://www.how2shout.com/linux/3-ways-to-install-ruby-on-ubuntu-22-04-lts-jammy/
sudo apt update && sudo apt install -y \
  nodejs \
  nano \
  ruby-full \
  git \
  curl \
  autoconf \
  bison \
  build-essential \
  libssl-dev \
  libyaml-dev \
  libreadline6-dev \
  zlib1g-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm6 \
  libgdbm-dev \
  libdb-dev
  
echo
echo "SETTING up VM on AWS..."
check_existing_project_directory
check_if_nano_installed

# Use curl to fetch the installation script from Github & pipe it directly to
# bash, to run the installer for an automated installation. See:
# https://github.com/rbenv/rbenv-installer#rbenv-installer
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
# shellcheck disable=SC2016
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

# Try 1: eval "$(rbenv init -)"
# Try 2: echo 'eval "$(rbenv init -)"' >> ~/.bashrc # Adds eval w init to end of .bashrc.
# Note: source ~/.bashrc - does NOT work & exits you out of script so rbenv
# can't be used.
# Try 3: Instead, use this eval line to configure your shell to load rbenv.
# shellcheck disable=SC2016
echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc

# RESTART YOUR SHELL - so that these changes take effect.
# shellcheck disable=SC1090,SC1091
eval "$(~/.rbenv/bin/rbenv init - bash)"
echo

echo "CHECKING for rbenv directory in: ~/.rbenv/bin/rbenv"
ls -lah ~/.rbenv/bin/rbenv
echo

# Kevin thinks: This should be: ls -lah ~/.rbenv/libexec/rbenv
# Is probably why your script is exiting: ls returns a non-zero status code
# & then the script exits because of the 'set -e' command near top of script.
echo "CHECKING for rbenv directory in: ~/.rbenv/libexec/rbenv"
ls -lah ~/.rbenv/libexec/rbenv
echo

echo "UPDATING rbenv & ruby-build with most recent versions..."
# Clone rbenv into ~/.rbenv.
# git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv
git pull

# https://github.com/rbenv/rbenv/blob/master/README.md#basic-git-checkout
# You need ruby-build plugin b/c it provides rbenv install command, which does 
# not ship with rbenv out-of-the-box.
# rbenv install ruby-build
cd ~/.rbenv/plugins/ruby-build/
git pull
echo

# Before trying to install Ruby, check your build environment has the necessary tools & libraries. Then:
# list latest stable versions:  rbenv install -l
# list all local versions:      rbenv install -L
# install a Ruby version:       rbenv install 3.1.2
# Using rbenv, install specific Ruby version for project that works with Rails 7.
echo
echo "INSTALLING rbenv with installer & then SPECIFIC RUBY VERSION with ruby-build using rbenv command..."
# sudo apt remove --autoremove ruby -y

echo "CHECKING the state of your rbenv installation..."
# Check the state of your rbenv installation with:
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash
echo

echo "LISTING Ruby versions already installed..."
rbenv install -l
echo

echo "SEEING if Ruby 3.1.2 is on system...CURRENTLY has:"
# https://github.com/rbenv/rbenv/blob/master/README.md#basic-git-checkout
# If the rbenv install command isn't found, install ruby-build as a plugin:
# git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
ruby -v
echo

# Check with: rbenv install -l (all installed versions) vs. ruby -v (system)
# B4: if ruby -v | grep -q "^ruby 3.1.2"; then
if rbenv install -l | grep -q "3.1.2"; then
  echo "The instance already HAS Ruby 3.1.2 so going to next step."
else
  echo "INSTALLING Ruby 3.1.2 since the instance does NOT have it..."
  echo
  # Add rbenv option to show progress of an rbenv command so I see more info.
  CONFIGURE_OPTS="--disable-install-rdoc" rbenv install --verbose 3.1.2
  echo "The system now has the Ruby version:"
  ruby -v
fi
echo

# rbenv global 3.1.2 # Sets system-wide default Ruby version, i.e., tells rbenv what Ruby version to use.
# rbenv local 3.1.2 # Specifies Ruby version for your project & creates .ruby-version file in the current directory.
# rbenv rehash
# echo

echo "CHECKING installation of rbenv..."
check_if_rbenv_installed
echo
echo "CHECKING installation of Ruby with by checking Ruby version..."
check_if_ruby_installed
echo

# TODO: Install Docker & Docker Compose.

# At this point at the end of script, you are passed back to main.sh and onto
# next command with launch_app.sh that runs the See Stuff web app.
