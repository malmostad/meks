Vagrant.configure('2') do |config|
  config.vm.box = 'bento/ubuntu-20.04'
  config.vm.hostname = 'www.local.malmo.se'

  config.vm.provider :virtualbox do |v|
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    v.memory = 1024 * 3
    v.cpus = 2
  end

  config.vm.network 'forwarded_port', guest: 3000, host: 3036
end
