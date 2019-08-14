# MEKS
MEKS is a management system for unaccompanied children, their asylum status, logistics and placements in homes. The system provides detailed statistics and Excel reports for further data modelling.

## Dependencies

* nginx (for production)
* Ruby 2.6.x
* MySQL >= 5.7
* ElasticSearch 6.x
* Memcached
* [Global Assets](https://github.com/malmostad/global-assets).

We use [Puppet](https://puppetlabs.com/) in standalone mode to setup development and server environments, see [puppet-mcommons](https://github.com/malmostad/puppet-mcommons/) for in-depth details.

## Development Setup

Development dependencies:

* [Vagrant](https://www.vagrantup.com/)
* A Vagrant compatible virtual machine such as VirtualBox or VMWare

To get the project files and create a Vagrant box with a ready-to-use development environment on your own machine, run the following commands:

```shell
$ git clone git@github.com:malmostad/meks.git
$ cd meks
$ vagrant up
```

Check the generated `install_info.txt` file in the project root for database details when the provisioning has finished.

Log in to the Vagrant box as the `vagrant` user and start the application in the Vagrant box:

```shell
$ vagrant ssh
$ cd /vagrant
$ rails s -b 0.0.0.0
```

Point a browser on your host system to http://127.0.0.1:3035. Editing of the project files on your host system will be reflected when you hit reload in your browser.

When you run the `vagrant up` command for the first time it creates an Ubuntu 16.04 based Vagrant box with a ready-to-use development environment for the application. This will take some time. Vagrant will launch fast after the first run.

If you get port conflicts in your host system, change `forwarded_port` in the `Vagrantfile` You might also want to edit the value for `vm.hostname` and `puppet.facter` in the same file or do a mapping `localhost` mapping in your hosts `host` file to reflect that value.


## Server Provisioning

The project contains resources for a standalone Puppet (no master) one-time provisioning setup. Do not run or re-run the provisioning on an existing server if you have made manual changes to config files generated by Puppet. It will overwrite.

On a fresh server running a base install of Ubuntu 16.04:

1. Add `app_runner` as a sudo user.
2. Log on to the server as `app_runner` and download the two provisioning files needed:

        $ wget https://raw.githubusercontent.com/malmostad/meks/master/puppet/bootstrap.sh
        $ wget https://raw.githubusercontent.com/malmostad/meks/master/puppet/server.pp

3. Run the provisioning:

        $ sudo bash ./bootstrap.sh

When finished, read the generated `install_info.txt` file in `app_runner`'s home directory for database details.

So, what happened?

* Nginx, MySQL, Elasticsearch and memcached are configured and installed as services
* A database ready for Rails migration is created (see deployment below)
* Logrotating and database backup are configured
* Snakeoil SSL certs are generated as placeholders
* Ruby is compiled and managed using [rbenv](https://github.com/sstephenson/rbenv) for the `app_runner` user.

The environment should now be ready for application deployment as described below.

The user `app_runner` must be used for all deployment task and for command executions related to the Rails application on the server. Rbenv is configured for that specific user only. The Rack application server, Unicorn, is run by `app_runner`.

## Post Provisioning on Server
To let `systemd` manage the `delayed_job` service on the server, edit the `RAILS_ENV` variable in `config/delayed_job.service`. Install the file in `/etc/systemd/system/` on the server and run:

```shell
$ sudo systemctl daemon-reload
$ sudo systemctl enable delayed_job
$ sudo service delayed_job start
$ sudo service delayed_job status
```

## Build and Deployment
Build and deployment is made with Capistrano 3.

In the project root, run one of the following commands including the appropriate environment name:

```shell
$ bundle exec cap staging deploy
$ bundle exec cap production deploy
```

The worker for delayed job that is used for gererating reports is managed by `systemd`. The process is killed after a deployment and `systemd` is starting it automaticaly.


## Testing
Run tests before pushing code to the Git repository and before making a deployment. The application contains unit tests and high level integration/feature tests using RSpec, Capybara and headless Chrome.

Note: Installation of Chrome, ChromeDriver and Selenium are currently not provided by the Puppet provisioning script for the Vagrant box. See `puppet/install_chrome_etc.txt` for installation commands.

Run the test cases in the projects root directory in your Vagrant box:

```shell
$ bundle exec rspec --exclude-pattern "./spec/unit/{family_and_emergency_home_cost,extra_contribution_cost}_spec.rb" --exclude_pattern "./spec/features/placements_spec.rb"
$ bundle exec rspec --pattern "./spec/unit/{family_and_emergency_home_cost,extra_contribution_cost}_spec.rb,./spec/features/placements_spec.rb" --pattern "./spec/features/placements_spec.rb"
```
Currently, rspec must be executed in two separate runs as you see above. This is because an rspec order issue that hasn't been tracked down yet.

Note that the environment used for RSpec is `local_test`.

## License
Released under AGPL version 3.
