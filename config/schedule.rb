# Whenever cron manager http://github.com/javan/whenever

# Installed w/capistrano: deploy.rb

# Check output with
# $ bundle exec whenever --set 'environment=production'

set :output, "#{path}/log/cron.log"
job_type :rake, 'cd :path && PATH=/usr/local/bin:$PATH RAILS_ENV=:environment bundle exec rake :task --silent :output'

every :day, at: '4:00am', roles: [:app] do
  rake 'reports:cleanup'
end
