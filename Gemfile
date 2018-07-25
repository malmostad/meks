source 'https://rubygems.org'

gem 'rails', '5.2.0'
gem 'haml-rails', '1.0.0'
gem 'sass-rails', '5.0.7'
gem 'uglifier', '4.1.16'
gem 'coffee-rails', '4.2.2'

gem 'simple_form', '4.0.1'
gem 'mysql2', '0.5.2'
gem 'dalli', '2.7.8'
gem 'elasticsearch-model', '5.1.0'
gem 'elasticsearch-rails', '5.1.0'
gem 'daemons', '1.2.6'

gem 'net-ldap', '0.16.1'
gem 'cancancan', '2.2.0'
gem 'ruby-saml', '1.8.0'

gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: '05f3412'
gem 'delayed_job_active_record', '4.1.3'

gem 'whenever', '0.10.0', require: false
gem 'highline', '2.0.0'
gem 'execjs', '2.7.0'
gem 'faker'

gem 'rails-i18n', '~> 5.1'

gem 'bcrypt', '~> 3.1.12'

gem 'pry-rails'

group :development do
  gem 'capistrano', '3.11.0', require: false
  gem 'capistrano-rails', '1.4.0', require: false
  gem 'capistrano-rbenv', '2.1.3', require: false
  gem 'capistrano-bundler', '1.3.0', require: false
  gem 'bullet'
  gem 'listen'
end

group :local_test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'poltergeist'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'
end

group :test, :production do
  gem 'unicorn', '5.4.1'
end
