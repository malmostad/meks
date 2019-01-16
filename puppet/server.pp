$envs = ['production']

$runner_name  = 'app_runner'
$runner_group = 'app_runner'
$runner_home  = '/home/app_runner'
$runner_path  = "${::runner_home}/.rbenv/shims:${::runner_home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"

$app_name       = 'meks'
$app_home       = "${::runner_home}/${::app_name}/current"

class { '::mcommons': }

class { '::mcommons::mysql':
  ruby_enable => true,
}

class { '::mcommons::elasticsearch':
  version => '6.x',
  memory  => '1g',
}

class { '::mcommons::memcached':
  memory => 512,
}

class { '::mcommons::nginx': }

class { '::mcommons::ruby':
  version => '2.5.3',
}

class { 'mcommons::ruby::unicorn': }
class { 'mcommons::ruby::rails': }
