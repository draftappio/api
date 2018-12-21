source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'

gem 'pg'

# Use Puma as the app server
gem 'puma'#, '~> 3.0'

# Background workers
gem 'sidekiq'
gem 'sinatra', require: false # For the Sidekiq panel

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', require: 'rack/cors'

# Authenication
gem 'devise_token_auth'
gem 'omniauth-oauth2'
gem 'omniauth-github'
gem 'omniauth-dropbox'
gem 'devise_invitable'

# To enable duplication of the associations
gem 'deep_cloneable', '~> 2.2.2'

# Environment variables managmenet
gem 'figaro'

# Decoration
gem 'draper', github: 'drapergem/draper'#, branch: 'support-rails-api'

# Slugging
gem 'friendly_id'

# Image uploads
gem 'paperclip', '~> 5.1.0'
gem 'paperclip-compression'
gem 'delayed_paperclip'

# Assets hosting
gem 'aws-sdk'

# Pagination
gem 'will_paginate', '~> 3.1.0'

# Activities
gem 'public_activity'

# Adminstration
gem 'rails_admin_rollincode', '~> 1.0'
gem 'rails_admin', '~> 1.0'

# Documentation
gem 'yard'
gem 'apipie-rails'
gem 'maruku'

gem 'rails_12factor', group: :production

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'awesome_print', require: 'ap'
  gem 'rubocop', require: false
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'webmock'
  gem 'simplecov', require: false
  gem 'factory_girl_rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
