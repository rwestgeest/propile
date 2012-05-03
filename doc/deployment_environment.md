# Deploying on an debian like system

## Assumptions about the environment

* You have a server with multiple ruby versions and using rvm to manage them
* You are not using ruby 1.9.3 as your default ruby
* The apache passenger module is from another version of ruby (e.g. ree) 

The latter point above makes you need to use a separate passenger
instance through proxypass

## Prerequisites

To deploy sucesfully, your system needs the following

### users and groups

Create a deployment user and make sure this user matches the user
specified in:

* config/deploy.rb 
* config/deploy_test.rb and
* config/deploy_prod.rb

I have used agilesytems

sudo adduser agilesystems
sudo addgroup deployer
sudo addgroup agilesystems deployer


### ssh environment

Make sure you have and .ssh directory with the correct permussions nad
put the deployers' keys in the .ssh/authorized_keys file

login as agilesystems

mkdir .ssh
chmod 700 .ssh

cat <some id_rsa.pub or id_dsa.pub> >> .ssh/authorized_keys

Test the setup by ssh'ing from to agilesystems@deployment-server

### software

You need the following software installed:

####git 

apt-test install git

#### rvm and ruby 1.9.3 with the prople gemset

install rvm through 

curl -L get.rvm.io | bash -s stable

make sure that your .bashrc contains:

export PATH=~/.rvm/bin:/opt/ree/bin:$PATH
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

in the interactive and non-interactive part (look for the 

if [ -z "$PS1" ]; then
  return
fi

section somewhere in the top of the file

make sure that your .bash_login contains

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

install ruby 1.9.3

rvm install 1.9.3

create propile gemset with at least bundler

rvm gemset create propile
rvm gemset use propile
gem install bundler

#### nvm and a javascript runtime

Rails assets need a javascript runtime. You can use nvm to install that 

git clone git://github.com/creationix/nvm.git ~/.nvm

make sur that your .bashrc and .bash_login contain:

. ~/.nvm/nvm.sh

nvm install v0.6.14

nvm use 0.6

nvm alias default 0.6

## install the application for the first time

rake vlad:setup vlad:setup_app
rake vlad:deploy:test

