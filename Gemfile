source 'http://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'

# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# TODO: Decide if to use Mongoid
# gem 'mongoid', git: 'https://github.com/estolfo/mongoid.git', branch: 'MONGOID-4218-rails-5'
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', require: 'rack/cors'

# Authenication
gem 'devise_token_auth'
gem 'omniauth-github'

# Environment variables managmenet
gem 'figaro'

# Documentation
gem 'yard'
gem 'apipie-rails'

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
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
