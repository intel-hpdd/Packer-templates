# Required settings
lang en_US.UTF-8
keyboard us
rootpw  --iscrypted $6$V24rApzWHJUm7l5h$YeMnlDdPT2IY4886QsR123p6JyEh40stITTy4icb1uHak8YiorV3ueN.Vnk94Esr41zd/W/z7zCVM.6Flq9km.
authconfig --enableshadow --passalgo=sha512
timezone UTC

# Optional settings
install
cdrom
user --name vagrant --homedir /home/vagrant --iscrypted --password $6$0BYdZGSQgFyb5xC.$TX3HXiFUGj4wcasVzk6pe3J.iYxA3y1iHzHNIxKu0J/py2LnjaZv9RSrNp2OjLCRfyJSf4R9KYcE3yjR4SalS/
unsupported_hardware
network --bootproto=dhcp
firewall --disabled
selinux --disabled
bootloader --location=mbr --append="no_timer_check console=tty0 console=ttyS0,115200"
text
skipx
zerombr
clearpart --all --initlabel
autopart
firstboot --disabled
reboot

%packages --nobase --ignoremissing --excludedocs
# vagrant needs this to copy initial files via scp
openssh-clients
# Prerequisites for installing VMware Tools or VirtualBox guest additions.
# Put in kickstart to ensure first version installed is from install disk,
# not latest from a mirror.
gcc
make
curl
wget
# Other stuff
sudo
nfs-utils
-fprintd-pam
-intltool

# Microcode updates cannot work in a VM
-microcode_ctl
# unnecessary firmware
-aic94xx-firmware
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-ipw*-firmware
-irqbalance
-ivtv-firmware
-iwl*-firmware
-libertas-usb8388-firmware
-ql*-firmware
-rt61pci-firmware
-rt73usb-firmware
-xorg-x11-drv-ati-firmware
-zd1211-firmware
%end

%post
# Versionlock kernel-headers
wget http://vault.centos.org/6.8/updates/x86_64/Packages/kernel-2.6.32-642.11.1.el6.x86_64.rpm
wget http://vault.centos.org/6.8/updates/x86_64/Packages/kernel-devel-2.6.32-642.11.1.el6.x86_64.rpm
wget http://vault.centos.org/6.8/updates/x86_64/Packages/kernel-headers-2.6.32-642.11.1.el6.x86_64.rpm
yum -y install yum-plugin-versionlock
yum install -y kernel-2.6.32-642.11.1.el6.x86_64.rpm kernel-devel-2.6.32-642.11.1.el6.x86_64.rpm kernel-headers-2.6.32-642.11.1.el6.x86_64.rpm
yum versionlock kernel-headers-2.6.32-642.11.1.el6.x86_64
# configure vagrant user in sudoers
echo "%vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i "s/^\(.*requiretty\)$/#\1/" /etc/sudoers
# keep proxy settings through sudo
echo 'Defaults env_keep += "HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY NO_PROXY"' >> /etc/sudoers
%end
