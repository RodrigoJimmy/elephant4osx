#!/usr/bin/env bash

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
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/root/index.html /usr/local/var/www/index.html
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/root/404.html /usr/local/var/www/404.html
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/root/403.html /usr/local/var/www/403.html
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/root/.info.php /usr/local/var/www/.info.php

## default site
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt
ln -sfv /usr/local/etc/nginx/sites-available/default /usr/local/etc/nginx/sites-enabled/default
ln -sfv /usr/local/etc/nginx/sites-available/default-ssl /usr/local/etc/nginx/sites-enabled/default-ssl

## nginx.new_site util
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/nginx/nginx.new_site -o /usr/local/bin/nginx.new_site
chmod +x /usr/local/nginx.new_site

# aliases
curl -L https://raw.githubusercontent.com/RodrigoJimmy/elephant4osx/master/config/term/.bash_aliases -o /tmp/aliases.tmp
cat /tmp/aliases.tmp >> ~/.bash_aliases
echo "source ~/.bash_aliases" >> ~/.bash_profile
source ~/.bash_profile
