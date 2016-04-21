
# El Capitan PHP envirnoment


## Install Xcode Command Line Tools
```sh
$ xcode-select --install
```

## Install homebrew
Open a terminal and install brew:
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

### check instalation
$ brew doctor
$ brew update && brew upgrade

## Install PHP-FPM
Because homebrew doesn't have a default formula for PHP, we need to add this first:
$ brew tap homebrew/dupes
$ brew tap homebrew/versions
$ brew tap homebrew/homebrew-php

Now install php-fpm:
$ brew install php56  --without-apache

To launch php-fpm on startup:
    mkdir -p ~/Library/LaunchAgents
    cp /usr/local/opt/php56/homebrew.mxcl.php56.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist

Make shure PHP-FPM is listening on port 9000:
$ lsof -Pni4 | grep LISTEN | grep php

## Install MySQL
$ brew install mysql

### Setup auto start
$ cp /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents/

### And start the database server
$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

### Secure the installation
$ mysql_secure_installation

Set a new root password and disallow remote root login, anonymous user, test database and last reload privilege tables.

## Install NGINX
We will set nginx to listen on port 80, so we will need some root privileges/permissions

$ sudo cp -v /usr/local/opt/nginx/*.plist /Library/LaunchDaemons/
$ sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist

 ### Test web server
 $ curl -IL http://127.0.0.1:8080

### Stop nginx
$ sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.nginx.plist

### Tunning up
mkdir -p /usr/local/etc/nginx/logs
mkdir -p /usr/local/etc/nginx/sites-available
mkdir -p /usr/local/etc/nginx/sites-enabled
mkdir -p /usr/local/etc/nginx/conf.d
mkdir -p /usr/local/etc/nginx/ssl
rm -f /usr/local/etc/nginx/nginx.conf
curl -L https://gist.github.com/frdmn/7853158/raw/nginx.conf -o /usr/local/etc/nginx/nginx.conf
curl -L https://gist.github.com/frdmn/7853158/raw/php-fpm -o /usr/local/etc/nginx/conf.d/php-fpm
curl -L https://gist.github.com/frdmn/7853158/raw/sites-available_default -o /usr/local/etc/nginx/sites-available/default
curl -L https://gist.github.com/frdmn/7853158/raw/sites-available_default-ssl -o /usr/local/etc/nginx/sites-available/default-ssl
rm -f /usr/local/var/www/*
git clone http://git.frd.mn/frdmn/nginx-virtual-host.git /usr/local/var/www
rm -rf /usr/local/var/www/.git

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt

ln -sfv /usr/local/etc/nginx/sites-available/default /usr/local/etc/nginx/sites-enabled/default
ln -sfv /usr/local/etc/nginx/sites-available/default-ssl /usr/local/etc/nginx/sites-enabled/default-ssl

sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist

curl -L https://gist.github.com/frdmn/7853158/raw/bash_aliases -o /tmp/.bash_aliases
cat /tmp/.bash_aliases >> ~/.bash_aliases

# If you use Bash
echo "source ~/.bash_aliases" >> ~/.bash_profile
source ~/.bash_profile

## Composer
$ brew install composer
$ composer selfupdate

## Laravel installer
$ composer global require "laravel/installer=~1.1"
$ echo "export PATH=\"$PATH:~/.composer/vendor/bin\"" >> ~/.bash_profile
$ mkdir ~/GitHub


## NVM
$ brew install nvm
$ echo "source $(brew --prefix nvm)/nvm.sh" >> ~/.bash_profile
$ nvm ls-remote
$ nvm install -s v0.12.5
if an error ocurred, re-run above command.

