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
# Install dependencies needed to build mellanox and lustre
yum install -y epel-release
yum -y groupinstall "Development Tools"
yum -y install xmlto asciidoc elfutils-libelf-devel zlib-devel binutils-devel newt-devel \
git tk createrepo python-devel pciutils lsof redhat-rpm-config rpm-build gcc \
gtk2 atk cairo gcc-gfortran tcsh libtool m4 automake \
python-devel hmaccalc perl-ExtUtils-Embed bison elfutils-devel audit-libs-devel \
pesign numactl-devel pciutils-devel ncurses-devel libselinux-devel \
asciidoc audit-libs-devel automake bc binutils-devel \
bison device-mapper-devel elfutils-devel elfutils-libelf-devel expect \
flex gcc gcc-c++ git glib2 glib2-devel hmaccalc keyutils-libs-devel \
krb5-devel ksh libattr-devel libblkid-devel libselinux-devel libtool \
libuuid-devel libyaml-devel lsscsi make ncurses-devel net-snmp-devel \
net-tools newt-devel numactl-devel parted patchutils pciutils-devel \
perl-ExtUtils-Embed pesign python-devel redhat-rpm-config rpm-build \
systemd-devel tcl tcl-devel tk tk-devel wget xmlto yum-utils zlib-devel

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
