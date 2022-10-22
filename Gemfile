source 'https://rubygems.org'

ruby '3.0.1'
gem "json", ">= 2.3.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>7.0', '>= 7.0.4'

# OLD Gemfile.lock actionpack (= 5.2.4.6)
gem 'actionpack', '~> 7.0'

gem 'puma', '~>5.6'
gem 'sqlite3'

gem "nokogiri", ">= 1.11.4"
# General library for manipulating & transforming HTML/XML documents &
# fragments, built on top of Nokogiri.
gem "loofah", ">= 2.3.1"

# Use SCSS for stylesheets
gem 'sass-rails', '>= 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '>= 5.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 2.10.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '>= 2.0.3', group: :doc

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
end
