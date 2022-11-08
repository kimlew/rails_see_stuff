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

check_if_rbenv_installed () {
  if ! command -v rbenv > /dev/null; then
    echo 'You must install the package manager, rbenv. For example, install with:'
    echo 'sudo apt install rbenv OR'
    echo 'brew install rbenv ruby-build'
    exit 1
  fi
}

check_current_directory
check_if_rbenv_installed

# Use specific version of Ruby for project that works with Rails 7.
# Install bundler which is required for rake commands for the database & items.
rbenv local 3.1.2
eval "$(rbenv init -)"
gem install bundler -v 2.3.22
bundle install

rake db:drop
rake db:create
rake db:migrate
rake db:seed

rails server
# View in browser at: http://localhost:3000
