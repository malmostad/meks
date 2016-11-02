source 'https://rubygems.org'

gem 'rails', '4.2.7.1'
gem 'haml-rails', '0.9.0'
gem 'sass-rails', '5.0.6'
gem 'uglifier', '3.0.2'
gem 'coffee-rails', '4.2.1'
gem 'jquery-rails'

gem 'simple_form', '3.3.1'
gem 'mysql2', '0.4.4'
gem 'dalli', '2.7.6'
gem 'elasticsearch-model', '0.1.9'
gem 'elasticsearch-rails', '0.1.9'
gem 'daemons', '1.2.4'

gem 'net-ldap', '0.15.0'
gem 'cancancan', '1.15.0'
gem 'ruby-saml', '1.3.1'

gem 'axlsx', '2.0.1'
gem 'delayed_job_active_record', '4.1.1'

gem 'whenever', '0.9.7', require: false
gem 'highline', '1.7.8'
gem 'execjs', '2.7.0'
gem 'faker'

gem 'bcrypt', '~> 3.1.11'

group :development do
  gem 'capistrano', '3.6.1'
  gem 'capistrano-rails', '1.1.7'
  gem 'capistrano-rbenv', '2.0.4'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'web-console'
  gem 'bullet'
end

group :local_test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
end

group :development, :test, :local_test do
  gem 'rspec-rails', '~> 3.5.2'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :test, :production do
  gem 'unicorn'
end
