# https://github.com/capistrano/rbenv
require 'erb'

I18n.config.enforce_available_locales = false

set :rbenv_type, :user
set :rbenv_ruby, '2.2.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :application, 'meks'
set :repo_url, "https://github.com/malmostad/#{fetch(:application)}.git"
set :user, 'app_runner'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :scm, :git
set :deploy_via, :remote_cache

# set :format, :pretty
# set :log_level, :debug
set :pty, true
set :forward_agent, true

set :linked_files, %w{config/database.yml config/app_config.yml config/secrets.yml }
set :linked_dirs, %w{log tmp/pids tmp/sockets}

set :default_env, { path: '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }
set :keep_releases, 5

namespace :deploy do
  %w[stop start restart upgrade].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: {no_release: true} do
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end

  desc "Full restart of unicorn server"
  task :full_restart do
    on roles(:app), except: {no_release: true} do
      execute "/etc/init.d/unicorn_#{fetch(:application)} restart"
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

  before :starting, "deploy:are_you_sure", "deploy:check_revision"
  after :published, "deploy:full_restart"
  after :finishing, "deploy:cleanup"
end
