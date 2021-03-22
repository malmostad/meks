# MEKS
MEKS is a management system for unaccompanied children, their asylum status, logistics and placements in homes. The system provides detailed statistics and Excel reports for further data modelling.

Note: If you just want to launch the system to check it out, you can use the [2.x-stable](https://github.com/malmostad/meks/tree/2.x-stable ) version that contains a one command Puppet setup.

## Dependencies
* Ruby 3.x managed by rbenv
* MySQL 8.x
* ElasticSearch 7.x
* Memcached
* [Global Assets](https://github.com/malmostad/global-assets).

## Development dependencies
* [Vagrant](https://www.vagrantup.com/)

## Development Setup
The following commands creates an Ubuntu 20.04 based Vagrant box.

```shell
$ git clone git@github.com:malmostad/meks.git
$ cd meks
$ vagrant up
$ vagrant ssh
```

1. Install the dependencies listed above.
2. Copy and edit the `config/secrets.yml.example` and `config/database.yml.example` files.
3. Create the databases for `config/database.yml`.

To run the application:

```shell
$ cd /vagrant
$ bundle exec puma
```
You can use seed files to create dummy data and three users, *a* (administrator) *w* (writer) and *r* (reader). After that you can login with one of the tree roles (no password).

```shell
$ bundle exec rake db:seed
$ bundle exec rake db:seed_rate_categories
```

Point a browser on your host system to http://127.0.0.1:3037. Editing of the project files on your host system will be reflected when you hit reload in your browser.

## Testing
Run tests before pushing code to the Git repository and before making a deployment. The application contains unit tests and high level integration/feature tests using RSpec, Capybara and headless Chromium.

See the `install_chromium.md` file for installation commands of Chromium.

Note that the environment used for RSpec currently is `local_test`.

Run the test cases in the projects root directory in your Vagrant box:

```shell
$ cd /vagrant
$ bundle exec rspec
```

If some tests fail, you may want to execute a second test run. This is because an Rspec order issue that hasn't been tracked down yet.

```shell
$ bundle exec rspec --only-failures
```

## Build and Deployment
Build and deployment is made with Capistrano.

In the project root, run one of the following commands including the appropriate environment name:

```shell
$ bundle exec cap staging deploy
$ bundle exec cap production deploy
```

The worker for delayed job that is used for generating reports is managed by `systemd`. The process is killed after a deployment and `systemd` is starting it automatically.

## License
Released under AGPL version 3.
