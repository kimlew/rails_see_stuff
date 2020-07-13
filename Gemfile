source 'https://rubygems.org'

ruby '~> 2.6.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.4.3'

# Use sqlite3 as the database for Active Record'
#gem 'sqlite3'

# Use Postgres for database
gem 'pg', '0.21.0'

gem "nokogiri", ">= 1.10.8"
# General library for manipulating & transforming HTML/XML documents &
# fragments, built on top of Nokogiri.
gem "loofah", ">= 2.3.1"

# Tool for running Rack applications, uses the Rack::Builder DSL to configure
# middleware & build up applications easily.
# gem "rack", "2.1.3"

# Use SCSS for stylesheets
gem 'sass-rails', '>= 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '>= 5.0.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 2.10.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.7.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
end

group :production do
  # Include this gem so images display
  gem 'rails_12factor'

  #gem 'mysql2'
end
