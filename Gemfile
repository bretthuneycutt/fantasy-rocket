ruby '2.1.2'
source 'https://rubygems.org'

gem 'rails', '4.1.5'
gem "pg"
gem 'email_validator'
gem 'haml-rails'
gem 'unicorn'
gem 'newrelic_rpm'
gem 'andand'

# sidekiq
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'rollbar'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :test do
  gem 'capybara'
  gem 'vcr'
  gem 'autotest'
  gem 'rspec-its'
end

group :production do
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
