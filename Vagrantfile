Vagrant.configure("2") do |config|

  # Prepare base box.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Configure forwarded ports.
  config.vm.network "forwarded_port", guest: 80, host: 8081, protocol: "tcp", auto_correct: true
  config.vm.network "forwarded_port", guest: 3306, host: 3307, protocol: "tcp", auto_correct: true

  config.vm.provision :shell, path: "bootstrap.sh"
end
