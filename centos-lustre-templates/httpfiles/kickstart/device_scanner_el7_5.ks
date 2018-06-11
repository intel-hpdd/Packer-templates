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
wget http://mirror.centos.org/centos/7.5.1804/updates/x86_64/Packages/kernel-3.10.0-862.2.3.el7.x86_64.rpm
wget http://mirror.centos.org/centos/7.5.1804/updates/x86_64/Packages/kernel-devel-3.10.0-862.2.3.el7.x86_64.rpm
wget http://mirror.centos.org/centos/7.5.1804/updates/x86_64/Packages/kernel-headers-3.10.0-862.2.3.el7.x86_64.rpm
yum -y install yum-plugin-versionlock
yum install -y kernel-3.10.0-862.2.3.el7.x86_64.rpm kernel-devel-3.10.0-862.2.3.el7.x86_64.rpm kernel-headers-3.10.0-862.2.3.el7.x86_64.rpm
yum versionlock kernel-headers-3.10.0-862.2.3.el7.x86_64

wget -P /etc/yum.repos.d https://copr.fedorainfracloud.org/coprs/managerforlustre/manager-for-lustre-devel/repo/epel-7/managerforlustre-manager-for-lustre-devel-epel-7.repo
rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
yum-config-manager --add-repo http://download.mono-project.com/repo/centos7/
yum install -y epel-release 
yum install -y mock
yum install -y rpkg
yum install -y dotnet-sdk-2.1
yum install -y yum-plugin-copr 
yum install -y mono-devel 
yum install -y nodejs 
yum install -y npm
yum install -y socat 
yum install -y jq  
yum install -y git 
yum install -y device-mapper-multipath 
yum install -y iscsi-initiator-utils
yum install -y scl-utils-build

adduser mockbuild
usermod -aG mock mockbuild

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
