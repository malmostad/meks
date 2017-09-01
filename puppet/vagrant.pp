$envs = ['development', 'test']

$runner_name  = 'vagrant'
$runner_group = 'vagrant'
$runner_home  = '/home/vagrant'
$runner_path  = "${::runner_home}/.rbenv/shims:${::runner_home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"

$app_name       = 'meks'
$app_home       = '/vagrant'

class { '::mcommons': }

class { '::mcommons::mysql':
  db_password      => '',
  db_root_password => '',
  create_test_db   => true,
  daily_backup     => false,
  ruby_enable      => true,
}

class { '::mcommons::elasticsearch':
  version => '5.x',
  memory  => '48m',
}

# -> exec {'Create ElasticSearch index':
#   command => "bundle exec rake environment elasticsearch:reindex RAILS_ENV=development CLASS='Recommendation' ALIAS='recommendations' ; exit 0",
#   user    => $::runner_name,
#   path    => $::runner_path,
#   cwd     => $::app_home,
# }
#
# -> exec {'Create ElasticSearch index for test':
#   command => "bundle exec rake environment elasticsearch:reindex RAILS_ENV=test CLASS='Recommendation' ALIAS='recommendations' ; exit 0",
#   user    => $::runner_name,
#   path    => $::runner_path,
#   cwd     => $::app_home,
# }

class { '::mcommons::memcached':
  memory => 16,
}

class { '::mcommons::ruby':
  version => '2.4.1',
}

class { 'mcommons::ruby::bundle_install': }
class { 'mcommons::ruby::rails': }
class { 'mcommons::ruby::rspec_deps': }
# mcommons::ruby::db_migrate { $::envs: }

class { 'mcommons::monit': }

# Puppet can't read local template files ...
-> file { "monit config for delayed_job":
  path    => "/etc/monit/conf.d/delayed_job",
  owner   => 'root',
  group   => 'root',
  mode    => '0700',
  content => inline_template('check process delayed_job
    with pidfile <%= @app_home -%>/tmp/pids/delayed_job.pid
    start program "<%= @runner_home -%>/run_with_rbenv ruby <%= @app_home -%>/bin/delayed_job start" as uid <%= @runner_name -%> and gid <%= @runner_group %>
    stop program  "<%= @runner_home -%>/run_with_rbenv ruby <%= @app_home -%>/bin/delayed_job stop" as uid <%= @runner_name -%> and gid <%= @runner_group -%> with timeout 120 seconds
    if cpu > 60% for 2 cycles then alert
    if cpu > 80% for 5 cycles then restart
    if memory usage > 70% for 5 cycles then restart
    if changed pid 2 times within 60 cycles then alert
  '),
}

-> exec { 'Reload Monit config after service config':
  command => '/usr/bin/monit reload',
}
