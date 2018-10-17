Vagrant.configure('2') do |config|
  config.vm.box = 'bento/ubuntu-16.04'
  config.vm.hostname = 'www.local.malmo.se'

  config.vm.provider :virtualbox do |v|
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    v.memory = 1024 * 3
    v.cpus = 2
  end

  config.vm.network 'forwarded_port', guest: 9292, host: 3036

  config.vm.provision :shell, path: 'puppet/bootstrap.sh'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet'
    puppet.manifest_file = 'vagrant.pp'
    puppet.module_path = 'puppet'
    puppet.facter = {
      'fqdn' => 'www.local.malmo.se'
    }
  end
end
