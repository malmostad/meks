# https://github.com/capistrano/rbenv
require 'erb'

I18n.config.enforce_available_locales = false

set :rbenv_type, :user
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :default_env, { path: '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_roles, :all

set :application, 'meks'
set :repo_url, "https://github.com/malmostad/#{fetch(:application)}.git"
set :user, 'app_runner'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :deploy_via, :remote_cache

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# set :format, :pretty
# set :log_level, :debug
set :pty, true
set :forward_agent, true

set :linked_files, %w{config/database.yml config/secrets.yml }
set :linked_dirs, %w{log tmp/pids tmp/sockets reports}

set :keep_releases, 5

namespace :unicorn do
  %w[stop start restart upgrade].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: {no_release: true} do
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end

  desc "Stop, paus and start the unicorn server"
  task :stop_start do
    on roles(:app) do
      execute "/etc/init.d/unicorn_#{fetch(:application)} stop && sleep 5 && /etc/init.d/unicorn_#{fetch(:application)} start"
    end
  end
end

namespace :delayed_job do
  desc 'Kill delayed job daemon, will be started up again by systemd'
  task :restart do
    on roles(:app) do
      execute "kill `cat #{fetch(:deploy_to)}/shared/tmp/pids/delayed_job.pid`"
    end
  end
end

namespace :cache do
  desc 'Clear Rails cache with rake task'
  task :clear do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to)}/current && $HOME/.rbenv/bin/rbenv exec bundle exec rake cache:clear RAILS_ENV=#{fetch(:rails_env)}"
    end
  end
end

namespace :deploy do
  desc "Copy vendor statics"
  task :copy_vendor_statics do
    on roles(:app) do
      execute "cp #{fetch(:release_path)}/vendor/chosen/*.png #{fetch(:release_path)}/public/assets/"
    end
  end

  task :setup do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{shared_path}/tmp"
      execute "mkdir -p #{shared_path}/log"
      execute "mkdir -p #{shared_path}/public/uploads"
    end
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc "Are you sure?"
  task :are_you_sure do
    on roles(:app) do |server|
      puts ""
      puts "Environment:   \033[0;32m#{fetch(:rails_env)}\033[0m"
      puts "Remote branch: \033[0;32m#{fetch(:branch)}\033[0m"
      puts "Server:        \033[0;32m#{server.hostname}\033[0m"
      puts ""
      puts "Do you want to deploy?"
      set :continue, ask("[y/n]:", "n")
      if fetch(:continue).downcase != 'y' && fetch(:continue).downcase != 'yes'
        puts "Deployment stopped"
        exit
      else
        puts "Deployment starting"
      end
    end
  end

  before :starting,       'deploy:are_you_sure'
  before :starting,       'deploy:check_revision'
  before :compile_assets, 'deploy:copy_vendor_statics'
  after  :publishing,     'unicorn:restart'
  after  :publishing,     'cache:clear'
  after  :publishing,     'delayed_job:restart'
  after  :finishing,      'deploy:cleanup'
end
