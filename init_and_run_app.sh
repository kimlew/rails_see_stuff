#! /usr/bin/env bash

# This script run the See Stuff application.
# Maybe: installs packages needed in environment to run rails_see_stuff.

# Check if rbenv is installed on system. If not: exit 1 & prompt user with msg:
# if rbenv -v != mac$ rbenv --version rbenv 1.2.0; then
#   echo 'You must install the package manager, rbenv version 1.2.0'
# end

# Check if in rails_see_stuff & if not: cd rails_see_stuff
# if current directory is not rails_see_stuff; then
#   cd rails_see_stuff
# end

rbenv local 3.0.4
# gem install rails -v 7.0
gem install bundler -v 2.3.22
# gem install puma -v 5.6.4
# gem install sqlite3
# gem install actionpack -v 7.0.4
bundle install

rake db:create
rake db:migrate
rake db:seed

rails server # -b", "0.0.0.0"]
# View in browser at: http://localhost:3000 # 48015/
