Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"
  config.ssh.insert_key = false
  config.vm.network "private_network", ip: "192.168.13.100", netmask: "255.255.255.0"
  config.vm.define "test" do |dev|
  dev.vm.provision "file", source: "#{Dir.home}/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  public_key = File.read("#{Dir.home}/.ssh/id_rsa.pub")
  dev.vm.provision :shell, :inline =>"
     echo 'Copying public SSH Keys to the VM'
     mkdir -p /home/vagrant/.ssh
     chmod 700 /home/vagrant/.ssh
     echo '#{public_key}' >> /home/vagrant/.ssh/authorized_keys
     chmod -R 600 /home/vagrant/.ssh/authorized_keys
     echo 'Host 192.168.13.*' >> /home/vagrant/.ssh/config
     echo 'StrictHostKeyChecking no' >> /home/vagrant/.ssh/config
     echo 'UserKnownHostsFile /dev/null' >> /home/vagrant/.ssh/config
     chmod -R 600 /home/vagrant/.ssh/config
     ", privileged: false
  dev.vm.provision "shell", inline: "
     echo 'Configuring network'
     sudo ip addr add 192.168.13.101/24 dev eth1
     sudo ip addr add 192.168.13.102/24 dev eth1
     sudo ip link set eth1 up
     echo '192.168.13.101 test1.local'|sudo tee -a  /etc/hosts
     echo '192.168.13.102 test2.local'|sudo tee -a  /etc/hosts
     echo 'Adding apt sources'
     wget -O- https://nginx.org/keys/nginx_signing.key| sudo apt-key add -
     echo 'deb http://nginx.org/packages/debian/ stretch nginx'|sudo tee -a  /etc/apt/sources.list
     echo 'deb-src http://nginx.org/packages/debian/ stretch nginx'|sudo tee -a  /etc/apt/sources.list 
     #wget -O- https://www.dotdeb.org/dotdeb.gpg| sudo apt-key add -
     #echo 'deb http://packages.dotdeb.org stretch all'|sudo tee -a  /etc/apt/sources.list 
     #echo 'deb-src http://packages.dotdeb.org stretch all'|sudo tee -a  /etc/apt/sources.list
     sudo apt-get update
     "
  dev.vm.provision "ansible", playbook: "zadanie.yml"
  dev.vm.provider "virtualbox" do |vb|
     vb.memory = "512"
end
end
end