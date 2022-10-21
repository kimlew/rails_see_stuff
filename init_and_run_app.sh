#! /usr/bin/env bash

# This script installs packages needed in environment to run rails_see_stuff.
#
# mkdir rails_see_stuff
# cd rails_see_stuff
# Check if in rails_see_stuff & if not: cd rails_see_stuff

sudo apt update && apt install -y \
  nodejs \
  nano \
  rbenv

rbenv local 3.0.1
gem install rails -v 7
gem install bundler -v 2.3.22
gem install puma
gem install sqlite3
gem install actionpack
bundle install

# First, copy locked Gemfile & Gemfile.lock & only installs missing gems.
# Then copy everything from app's current directory on host into app container's
# root directory. This copy includes locked Gemfile & Gemfile.lock, so
# container has app code AND correct dependencies. Can use . or $INSTALL_PATH
# for current dir since WORKDIR set to /opt/rails7_task_manager.
# bundle check || bundle install - checks that the gems are not already installed before installing them.
# Copying these files as an independent step, followed by bundle install, means that the project gems do not need to be rebuilt every time you make changes to your application code. This will work in conjunction with the gem volume that we will include in our Compose file, which will mount gems to your application container in cases where the service is recreated but project gems remain the same.
# See: https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose
cp Gemfile .
cp Gemfile.lock .
bundle check || bundle install

rake db:create
rake db:migrate
rake db:seed

rails server # -b", "0.0.0.0"]
# View in browser at: http://localhost:3000 # 48015/
