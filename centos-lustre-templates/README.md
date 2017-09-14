# Packer Templates for Lustre Development and Testing

This repository contains standard templates to define base virtual machines using a tool called Packer to create profiles in a consistent, reliable and repeatable manner. Packer is able to create base VMs for multiple platforms, including VirtualBox, VMWare, Azure and AWS.

The templates in this repository are currently able to create VirtualBox VMs, and are intended to support software developers, testers and those wishing to evaluate the Lustre file system and its supporting tools.

The VMs created by Packer are formatted into packages called "boxes" and can be used as the basis for Vagrant projects. In addition to creating the boxes, these templates will also upload boxes to the Vagrant Cloud repository (Vagrant Cloud replaces the Atlas service provided by Hashicorp for sotrage of Vagrant images. Atlas still exists, providing services for commercial use, but the free tier has been moved to Vagrant Cloud).

More information regarding Packer and Vagrant can be found at their respective project web sites:

https://www.packer.io/
https://www.vagrantup.com/

For those who are new to this suite of tools, the following site from the company behind these projects provides an introduction:

https://www.hashicorp.com/

Packer and Vagrant are tools in a workflow, and there are many ways one can make use of them. For the purposes of Lustre and the set of management tools, Packer is currently used to create base VM images, Vagrant Cloud is the storage repository for the images and Vagrant is used to instantiate development clusters and build servers.

The repository for the Lustre developer Vagrant templates is here:

https://github.com/intel-hpdd/Vagrantfiles

## Getting Started with the Templates

### Download and install Packer

Download Packer from the following URL:

https://www.packer.io/downloads.html

Packer is written in Go, and for Linux-based operating systems it is distributed as a single, statically-linked binary. There is no packaging; just download the file and store in a location in your shell's PATH. 

**Note:** In some distributions, there is a name confict with another application. For example, on Fedora, `/usr/sbin/packer` is part of the `cracklib-dicts` package. Either change the `PATH`  order for the user account, or rename the binary to `packer.io`, or `packer.vmm`, or something similar that makes sense to the build environment. The documentation will just refer to the command name `packer`. Refer to the [Packer documentation](https://www.packer.io/docs) for more information.

### Vagrant Cloud Tokens and Packer 

For users who wish to store boxes in Vagrant Cloud, sign up to Vagrant for an account and create a token for managing authentication. It may also be beneficial to set up a command alias that sources the token on demand, rather than having it persistent in the shell environment. For example, keep the token in a file called `$HOME/.vagrant_token` as a shell variable:

```bash
cat > $HOME/.vagrant_token <<__EOF
VAGRANT_CLOUD_TOKEN="<token>"
__EOF
```

Create a BASH alias. For example:

```bash
alias packer-vagrant-cloud=". $HOME/.vagrant_token && $HOME/bin/packer"
```

### Download an install VirtualBox

Refer to the VirtualBox project for information on downloading and installing VirtualBox.


### Clone the Git repository

```
cd $HOME
git clone git@github.com:intel-hpdd/Packer-templates.git
```

### Use Packer to Create Boxes

The following commands show how to create Vagrant boxes with packer and upload them to Vagrant Cloud:


#### Lustre Server

```
cd $HOME/Packer-templates/centos-lustre-templates
./scripts/download-lustre-server-el7.sh <lustre version>
./scripts/download-lustre-e2fsprogs-el7.sh
cd lustre
export VAGRANT_CLOUD_TOKEN=<token>
packer build \
  -var 'account_name=<vagrant account>' \
  -var 'box_name=lustre-server-el7' \
  -var 'version=<lustre version>' \
  lustre-server-ldiskfs-packerfile-el7.json 
```

The `<version>` number is in the format `x.y.z`.

#### Lustre Client

```
cd $HOME/Packer-templates/centos-lustre-templates
./scripts/download-lustre-client-el7.sh <lustre version>
cd lustre
export VAGRANT_CLOUD_TOKEN=<token>
packer build \
  -var 'account_name=<vagrant account>' \
  -var 'box_name=lustre-client-el7' \
  -var 'version=<lustre version>' \
  lustre-client-packerfile-el7.json 
```

The `<version>` number is in the format `x.y.z`.

#### CentOS 7.4 Base

```
cd $HOME/Packer-templates/centos-lustre-templates/centos-7.4
export VAGRANT_CLOUD_TOKEN=<token>
packer build \
  -var 'account_name=<vagrant account>' \
  -var 'box_name=centos74-1708-base' \
  -var 'version=<version>' \
  centos74-1708-base-packerfile.json
```

The `<version>` number can be any unique number of the format `x.y.z`.

#### CentOS 7.4 Base + Updates

```
cd $HOME/Packer-templates/centos-lustre-templates/centos-7.4
export VAGRANT_CLOUD_TOKEN=<token>
packer build \
  -var 'account_name=<vagrant account>' \
  -var 'box_name=centos74-1708-update' \
  -var 'version=<version>' \
  centos74-1708-update-packerfile.json 
```

The `<version>` number can be any unique number of the format `x.y.z`.

#### CentOS 7 Developer

```
cd $HOME/Packer-templates/centos-lustre-templates
export VAGRANT_CLOUD_TOKEN=<token>
packer build \
  -var 'account_name=<vagrant account>' \
  -var 'box_name=centos74-1708-builder' \
  -var 'version=<version>' \
  centos74-1708-builder-packerfile.json 
```


## Overview of the Templates

Packer templates are written in JSON. The templates in this project comprise four sections:

1. Comment block. This is a hack to allow comments in JSON, since the JSON format does not itself support comments. Instead, at the top level of the data structure, a set of comment key-value pairs is created.
1. Variables: set of user variables that can be set on the packer command line
1. Builders: a set of one or more virtual machine definitions used to create VMs for different platforms. The current packer templates define a VirtualBox builder.
1. Provisioners: a set of comamnds to run either on the VM or on the hypervisor host. Provisioners can be shell scripts, files to copy or configuration management recipes for Ansible, Chef, Puppet, and others.
1. Post-processors: these define how to package the results of a build. The templates in this project create boxes for Vagrant and will also upload those boxes to Vagrant Cloud.


The CentOS base boxes are straightforward. For each minore release of CentOS, starting with CentOS 7.3, there is a directory containing the following Packer templates: 

* centos*-base-packerfile.json installs a base operating system with a minimum number of packages to get a working operating system.
* centos*-update-packerfile.json is the same as the base template but also runs an update against installed packages.
* centos*-builder-packerfile.json installs software development tools necessary to support devleopment of Lustre and ZFS, but does not install Lustre or ZFS source code. The builder profile also runs an update to make sure the base VM is up to date at time of creation.

There are also two Lustre templates, one for clients and one for servers:

* lustre-client-packerfile-el7.json
* lustre-server-ldiskfs-packerfile-el7.json

These are built from the same base kickstart template as `centos*-base-packerfile.json`, but add the Lustre client and Lustre server packages, respectively, creating ready-to-run Lustre VMs. The Lustre Packer templates are created using the latest version of CentOS that has been tested for Lustre.

The templates accept variables to allow users to define the account and the name of the box on Vagrant, and the Lustre templates have an additional variable to set the version of Lustre to install.

## VM Creation and OS Installation

The builders are responsible for creating a virtual machine, complete with storage for the OS, and for starting the OS installation process. A builder must be able to access the OS install medium, which can be a local ISO file or it can be downloaded directly from a distribution site. The CentOS builders in this project use the `kernel.org` mirror but this can easily be changed by editing the templates. Images are downloaded once and then cached, conserving bandwidth and reducing time to build.

Packer builders rely on automation, so each builder must be able to support unattended installation. For RHEL and CentOS, this means creating a Kickstart template. The templates are stored in a directory called `httpfiles/kickstart`. Packer will create a web server for the builder to use so that the kickstart template can be retrieved by the installer. The details of this mechanism are explained in the [Packer documentation](http://packer.io/docs), but suffice to say that the builder retrieves the ISO image, attaches it to the VM when it boots the machine and then edits the boot loader to make sure that the installer picks up the Kickstart template. 

When the OS installation is complete, the VM is rebooted, and the Provisioner scripts are run, if there are any such defined.

For the VirtualBox builder, guest additions have not been included, and as a consequence, the shared folder support in the VM is also disabled. This is done to simplify distribution and ensure the broadest level of compatibility of the Vagrant VM across different VirtualBox installations. Guest additions can be added into `Vagrantfile` definitions if needed. This is not great, but avoids some issues with provisioning VMs where guest additions don't install cleanly. Also means the box doesn't need the Developer Tools package cluster, so the base image is simpler.

If this is not desirable, then remove the following from the `vagrant` `post-processor`:

```
"vagrantfile_template": "Vagrantfile",
```

Vagrant instances that do not have guest additions installed can still use the `rsync` mechanism to synchronise files between the host and the guest.

## Packaging and Distribution with Post-processors

The post-processors are responsible for packaging the completed VM and any other artefacts for distribution. In this project, VMs are packaged into Vagrant boxes, then uploaded to Vagrant Cloud.

The Vagrant Cloud post-processor requires a valid account name, box name, and version number. If a version already exists in Vagrant for a given box, the upload will fail. To enable uploads, a valid token is also required. Set the token in an environment variable called VAGRANT_CLOUD_TOKEN, or use the shell environment in the section [Vagrant Cloud Tokens and Packer](#vagrant-cloud-tokens-and-packer).

**Note:** It may be necessary to create an empty, unversioned, box in Vagrant Cloud before running a Packer build. We have experienced failures when trying to upload new boxes to Vagrant Cloud, and the simplest solution is to log into the account, create a new Vagrant box from the dashboard making sure the name matches the one that will be used for the build, then re-run the `packer build` command.

## User accounts and SSH Keys in Vagrant Boxes

By convention, public boxes created for use by Vagrant have a default user called `vagrant` with password `vagrant`. The root user account will also, by convention, have a password of `vagrant`.

The `vagrant` account uses a known SSH key that is kept on the Vagrant GitHub project page. This is a known security risk and is made by design. All public Vagrant VMs will share this convention. The key is always replaced by vagrant with a newly generated SSH key every time a new instance is created but this highlights that Vagrant itself is really intended for internal developer use, rather than a production deployment. The vagrant user is also expected to have unrestricted `sudo` access to the VM, without requiring a password.


The default insecure public key for the vagrant user is available from the following URL:

https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub

Please also read the note in the Vagrant GitHub repo:

https://github.com/mitchellh/vagrant/blob/master/keys/README.md

The kickstart templates for this project maintain this convention, but it is not mandatory for private projects, or for users who wish to create production VMs (i.e. VMs that are not being made for Vagrant). If this is changed, be aware that the Packer templates depend on knowing the user name and password of an account on the guest VM and will need to be modified accordingly.

Passwords can be created using the following python one-liner, where the password being encrypted is the first argument to the 'crypt' method (i.e. 'vagrant'):

	python -c 'import crypt; \
	  print(crypt.crypt("vagrant",salt=crypt.METHOD_SHA512))'

## A Note on the Lustre Install

The Lustre templates make use of some shell scripts that download the RPM packages from the main Lustre download repository, and then copy and install the RPMs onto the VM during the provisioning step. In order to keep the direcotry structure clean, the files are downloaded into a directory hierarchy. Unfortunately, Packer will fail with an error if it cannot locate the directories.

The directiroy hierarchy could be simplified, but is maintained in order that the same template can be used to create boxes for different versions of Lustre. The simplest solution is to run the download scripts before running the `packer build` task.

```
cd $HOME/Packer-templates/centos-lustre-templates
./scripts/download-lustre-client-el7.sh <version>
./scripts/download-lustre-server-el7.sh <version>
./scripts/download-lustre-e2fsprogs-el7.sh
```


## Limitations

Currently, only VirtualBox VMs are created. Additional builder types will be added over time.

Versioning of Vagrant boxes is currently restricted to 3 numerals in the form `x.y.z`. This is a limitation imposed by Hashicorp's software platform. Some Lustre releases may have an additional digit to denote hot fixes, in which case the version number in the template would need to be changed.

An alternative may be to let Vagrant manage the versioning automatically.

