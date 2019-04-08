source 'https://rubygems.org'

gem 'rails', '5.2.2.1'
gem 'haml-rails', '2.0.0'
gem 'sassc-rails', '2.1.0'
gem 'uglifier', '4.1.20'
gem 'coffee-rails', '4.2.2'

# Version 1.5 that is included in Malmo Global Assets have bugs in the date range selector
gem 'bootstrap-datepicker-rails', '1.8.0.1'

gem 'simple_form', '4.1.0'
gem 'mysql2', '0.5.2'
gem 'dalli', '2.7.10'
gem 'elasticsearch-model', '6.0.0'
gem 'elasticsearch-rails', '6.0.0'
gem 'daemons', '1.3.1'

gem 'net-ldap', '0.16.1'
gem 'cancancan', '2.3.0'
gem 'ruby-saml', '1.9.0'

gem 'rubyzip', '~> 1.2.2'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c593a08'
gem 'axlsx_rails'
gem 'delayed_job_active_record', '4.1.3'

gem 'whenever', '0.10.0', require: false
gem 'highline', '2.0.1'
gem 'execjs', '2.7.0'
gem 'faker'

gem 'rails-i18n', '~> 5.1'

gem 'bcrypt', '~> 3.1.12'

gem 'pry-rails'

group :development do
  gem 'capistrano', '3.11.0', require: false
  gem 'capistrano-rails', '1.4.0', require: false
  gem 'capistrano-rbenv', '2.1.4', require: false
  gem 'capistrano-bundler', '1.5.0', require: false
  gem 'bullet'
  gem 'listen'
  gem 'rails-erd'
end

group :local_test do
  gem 'puma'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails', '5.0.1'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end

group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :test, :production do
  gem 'unicorn', '5.5.0'
end
