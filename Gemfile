source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'haml-rails', '0.9.0'
gem 'sass-rails', '~> 5.0.4'
gem 'uglifier', '~> 3.0.0'
gem 'coffee-rails', '4.1.1'
gem 'jquery-rails'

gem 'simple_form', '3.2.1'
gem 'mysql2', '~> 0.4.3'
gem 'dalli', '2.7.6'
gem 'elasticsearch-model', '0.1.8'
gem 'elasticsearch-rails', '0.1.8'

gem 'net-ldap'
gem 'cancancan'

gem 'axlsx'

gem 'whenever', '0.9.4', require: false
gem 'highline'
gem 'execjs'
gem 'faker'

# gem 'jbuilder', '~> 2.3.2'

gem 'bcrypt', '~> 3.1.11'

group :development do
  gem 'capistrano', '3.4.0'
  gem 'capistrano-rails', '1.1.6'
  gem 'capistrano-rbenv', '2.0.4'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'web-console'
  gem 'bullet'
end

group :local_test do
  gem 'rspec-rails', '~> 3.4.0'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'rb-readline'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :test, :production do
  gem 'unicorn'
end
