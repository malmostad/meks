source 'https://rubygems.org'

gem 'rails', '5.2.4.5'
gem 'haml-rails', '2.0.1'
gem 'sassc-rails', '2.1.2'
gem 'uglifier', '4.2.0'
gem 'coffee-rails', '5.0.0'

# Version 1.5 that is included in Malmo Global Assets have bugs in the date range selector
gem 'bootstrap-datepicker-rails', '1.9.0.1'

gem 'simple_form', '5.1.0'
gem 'mysql2', '0.5.3'
gem 'dalli', '2.7.11'
gem 'elasticsearch-model', '7.1.1'
gem 'elasticsearch-rails', '7.1.1'
gem 'daemons', '1.3.1'

gem 'net-ldap', '0.17.0'
gem 'cancancan', '3.2.1'
gem 'ruby-saml', '1.12.0'

gem 'caxlsx', '3.0.4'
gem 'caxlsx_rails', '0.6.2'
gem 'delayed_job_active_record', '4.1.5'

gem 'whenever', '1.0.0', require: false
gem 'highline', '2.0.3'
gem 'execjs', '2.7.0'
gem 'faker'

gem 'rails-i18n', '5.1.3'

gem 'bcrypt', '3.1.16'

gem 'pry-rails'

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'capistrano', '3.16.0', require: false
  gem 'capistrano-rails', '1.6.1', require: false
  gem 'capistrano-rbenv', '2.2.0', require: false
  gem 'capistrano-bundler', '2.0.1', require: false
  gem 'bullet'
  gem 'listen'
  gem 'rails-erd'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :local_test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end

group :development, :local_test do
  gem 'puma'
end

group :test, :production do
  gem 'unicorn', '5.8.0'
end
