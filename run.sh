#!/usr/bin/env bash

echo "Installing Command Line Tools \
just click on 'Install' button.\n
Press [RETURN] to proceed"
xcode-select --install

echo "Installing homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "checking brew installation"
brew doctor && brew update && brew upgrade

echo "Installing PHP-FPM"
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
brew install php56  --without-apache

echo "Setup PHP-FPM auto start"
mkdir -p ~/Library/LaunchAgents
cp /usr/local/opt/php56/homebrew.mxcl.php56.plist ~/Library/LaunchAgents/


echo "Installing MySQL"
brew install mysql

echo "Setup MySQL auto start"
cp /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents/

echo "Secure the installation"
echo "Set a new root password and disallow remote root login, anonymous user, test database and last reload privilege tables."
mysql_secure_installation

echo "Installing NGINX"
echo "We will set nginx to listen on port 80, so we will need some root privileges/permissions"
sudo cp -v /usr/local/opt/nginx/*.plist /Library/LaunchDaemons/

mkdir -p /usr/local/etc/nginx/logs
mkdir -p /usr/local/etc/nginx/sites-available
mkdir -p /usr/local/etc/nginx/sites-enabled
mkdir -p /usr/local/etc/nginx/conf.d
mkdir -p /usr/local/etc/nginx/ssl
rm -f /usr/local/etc/nginx/nginx.conf

## TODO: change urls to my git repo
/usr/local/etc/nginx/nginx.conf
curl -L https://gist.github.com/frdmn/7853158/raw/php-fpm -o /usr/local/etc/nginx/conf.d/php-fpm
curl -L https://gist.github.com/frdmn/7853158/raw/sites-available_default -o /usr/local/etc/nginx/sites-available/default
curl -L https://gist.github.com/frdmn/7853158/raw/sites-available_default-ssl -o /usr/local/etc/nginx/sites-available/default-ssl
rm -f /usr/local/var/www/*
git clone http://git.frd.mn/frdmn/nginx-virtual-host.git /usr/local/var/www
rm -rf /usr/local/var/www/.git

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt

ln -sfv /usr/local/etc/nginx/sites-available/default /usr/local/etc/nginx/sites-enabled/default
ln -sfv /usr/local/etc/nginx/sites-available/default-ssl /usr/local/etc/nginx/sites-enabled/default-ssl

cat /config/term/.bash_aliases >> ~/.bash_aliases
echo "source ~/.bash_aliases" >> ~/.bash_profile
source ~/.bash_profile

echo "Installing Composer"
brew install composer
composer selfupdate

echo  "Installing Laravel installer"
composer global require "laravel/installer=~1.1"
echo "export PATH=\"$PATH:~/.composer/vendor/bin\"" >> ~/.bash_profile


echo "Installing nvm, npm and node"
brew install nvm
echo "source $(brew --prefix nvm)/nvm.sh" >> ~/.bash_profile
nvm ls-remote
nvm install -s v0.12.5
nvm install -s v0.12.5


