source 'https://rubygems.org'

gem 'rails', '4.2.5'
gem 'haml-rails', '0.9.0'
gem 'sass-rails', '~> 5.0.4'
gem 'uglifier', '~> 2.7.2'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails'

gem 'simple_form', '3.2.0'
gem 'mysql2', '~> 0.4.2' #'0.3.20'
gem 'dalli', '2.7.4'
gem 'elasticsearch-model', '0.1.8'
gem 'elasticsearch-rails', '0.1.8'

gem 'whenever', '0.9.4', require: false
gem 'highline'
gem 'execjs'
gem 'faker'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.3.2'

gem 'bcrypt', '~> 3.1.10'

group :development do
  gem 'capistrano', '3.4.0'
  gem 'capistrano-rails', '1.1.5'
  gem 'capistrano-rbenv', '2.0.3'
  gem 'net-ldap' #, '0.3.1' # '0.3.1' works, 0.5 and 0.6 (0.10.1?) have an encoding issue: https://github.com/ruby-ldap/ruby-net-ldap/pull/82

  gem 'pry-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.4.0'
  gem 'quiet_assets'
  gem 'thin'
  gem 'rb-readline'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :test, :production do
  gem 'unicorn'
end
