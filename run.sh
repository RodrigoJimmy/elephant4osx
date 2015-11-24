#!/usr/bin/env bash

echo "Installing Command Line Tools \
just click on 'Install' button.\n
Press [RETURN] to proceed"
xcode-select --install

echo "Installing homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "checking brew installation"
brew doctor && brew update && brew upgrade


echo "Setting brew taps"
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
brew tap homebrew/nginx

echo "Installing packages"
brew install php56  --without-apache
brew install mysql nginx composer
composer selfupdate


echo "Setup auto start (optional)"
mkdir -p ~/Library/LaunchAgents
ln -sfv /usr/local/opt/php56/homebrew.mxcl.php56.plist ~/Library/LaunchAgents/
ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents/

echo "Nginx auto start with root permissions due to running on port 80"
sudo cp /usr/local/opt/nginx/*.plist /Library/LaunchAgents/
sudo chmod +x /Library/LaunchAgents/homebrew.mxcl.nginx.plist


echo "Secure the installation (just say y|Y to all questions)"
mysql.server start
mysql_secure_installation
sed -i.bak 's/127.0.0.1:9000/\/usr\/local\/var\/run\/php5-fpm.sock/g' /usr/local/etc/php/5.6/php-fpm.conf


mkdir -p /usr/local/etc/nginx/logs
mkdir -p /usr/local/etc/nginx/sites-available
mkdir -p /usr/local/etc/nginx/sites-enabled
mkdir -p /usr/local/etc/nginx/conf.d
mkdir -p /usr/local/etc/nginx/ssl
rm -f /usr/local/etc/nginx/nginx.conf

curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/nginx.conf -o /usr/local/etc/nginx/nginx.conf
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/php-fpm -o /usr/local/etc/nginx/conf.d/php-fpm
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/default -o /usr/local/etc/nginx/sites-available/default
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/default-ssl -o /usr/local/etc/nginx/sites-available/default-ssl

rm -f /usr/local/var/www/*
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/root/index.html -o /usr/local/var/www/index.html
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/root/404.html -o /usr/local/var/www/404.html
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/root/403.html -o /usr/local/var/www/403.html
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/root/.info.php -o /usr/local/var/www/.info.php

## default site
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt
ln -sfv /usr/local/etc/nginx/sites-available/default /usr/local/etc/nginx/sites-enabled/default
ln -sfv /usr/local/etc/nginx/sites-available/default-ssl /usr/local/etc/nginx/sites-enabled/default-ssl

## serve-laravel.sh
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/serve-laravel.sh -o /usr/local/bin/serve-laravel.sh
chmod +x /usr/local/bin/serve-laravel.sh

curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/term/.bash_aliases -o ~/.bash_aliases
echo "source ~/.bash_aliases" >> ~/.bash_profile
source ~/.bash_profile


echo  "Installing Laravel installer"
composer global require "laravel/installer=~1.1"
echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ../.bash_profile

