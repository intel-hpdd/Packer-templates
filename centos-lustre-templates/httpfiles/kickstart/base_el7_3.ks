# Anaconda environment
install
text
reboot

# Locale defaults
lang en_US.UTF-8
keyboard us
timezone --utc America/New_York

# Network
network --device eth0 --onboot yes --bootproto dhcp

# OS boot/root disk
bootloader --location=mbr --append="crashkernel=auto console=ttyS0,115200 rd_NO_PLYMOUTH"
zerombr
clearpart --all --initlabel
autopart

# Authentication for local user accounts
authconfig --enableshadow --passalgo=sha512
# Root password
rootpw  --iscrypted $6$V24rApzWHJUm7l5h$YeMnlDdPT2IY4886QsR123p6JyEh40stITTy4icb1uHak8YiorV3ueN.Vnk94Esr41zd/W/z7zCVM.6Flq9km.
# Default user for Vagrant boxes (required)
user --name vagrant --homedir /home/vagrant --iscrypted --password $6$0BYdZGSQgFyb5xC.$TX3HXiFUGj4wcasVzk6pe3J.iYxA3y1iHzHNIxKu0J/py2LnjaZv9RSrNp2OjLCRfyJSf4R9KYcE3yjR4SalS/

firewall --disabled
selinux --disabled

%packages
@core
@base
%end

%pre

%end

%post
# Versionlock kernel-headers
wget http://vault.centos.org/7.3.1611/updates/x86_64/Packages/kernel-3.10.0-514.10.2.el7.x86_64.rpm
wget http://vault.centos.org/7.3.1611/updates/x86_64/Packages/kernel-devel-3.10.0-514.10.2.el7.x86_64.rpm
wget http://vault.centos.org/7.3.1611/updates/x86_64/Packages/kernel-headers-3.10.0-514.10.2.el7.x86_64.rpm
yum -y install yum-plugin-versionlock
yum install -y kernel-3.10.0-514.10.2.el7.x86_64.rpm kernel-devel-3.10.0-514.10.2.el7.x86_64.rpm kernel-headers-3.10.0-514.10.2.el7.x86_64.rpm
yum versionlock kernel-headers-3.10.0-514.10.2.el7.x86_64
# Download the default public key for the vagrant user from the 
# Vagrant GitHub project. Used by all public base boxes for first
# time boot.
mkdir -m 0700 /home/vagrant/.ssh
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Add vagrant user to SUDO configuration with no password
# (required for public vagrant boxes)
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
%end
