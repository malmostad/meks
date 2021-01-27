$envs = ['development', 'test']

$runner_name  = 'vagrant'
$runner_group = 'vagrant'
$runner_home  = '/home/vagrant'
$runner_path  = "${::runner_home}/.rbenv/shims:${::runner_home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"

$app_name       = 'meks'
$app_home       = '/vagrant'

class { '::mcommons': }

-> class { '::mcommons::mysql':
  db_password      => '',
  db_root_password => '',
  create_test_db   => true,
  daily_backup     => false,
  ruby_enable      => true,
}

-> class { '::mcommons::elasticsearch':
  version => '5.x',
  memory  => '200m',
}

-> class { '::mcommons::memcached':
  memory => 16,
}

-> class { '::mcommons::ruby':
  version => '2.6.3', # Use the version from .ruby-version
}

-> exec { 'Update Gem System':
  command => '/usr/bin/env gem update --system',
  user    => $::runner_name,
  path    => $::runner_path,
  cwd     => $::app_home,
}

-> class { 'mcommons::ruby::bundle_install': }
-> class { 'mcommons::ruby::rails': }
-> class { 'mcommons::ruby::rspec_deps': }

-> exec { "Load schema to database":
  command => "bundle exec rake db:schema:load",
  user    => $::runner_name,
  path    => $::runner_path,
  cwd     => $::app_home,
}
