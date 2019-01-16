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
  version => '6.x',
  memory  => '200m',
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
  version => '2.5.3',
}

class { 'mcommons::ruby::bundle_install': }
class { 'mcommons::ruby::rails': }
class { 'mcommons::ruby::rspec_deps': }
# mcommons::ruby::db_migrate { $::envs: }
