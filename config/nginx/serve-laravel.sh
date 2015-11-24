#!/usr/bin/env bash

## use: serve-laravel.sh blog.app /Users/rodrigo/GitHub/blog/public 80 443

# /etc/nginx/ssl -> /usr/local/etc/nginx/ssl

BASE_DIR="/usr/local"
PATH_SSL="${BASE_DIR}/etc/nginx/ssl"
PATH_KEY="${PATH_SSL}/${1}.key"
PATH_CSR="${PATH_SSL}/${1}.csr"
PATH_CRT="${PATH_SSL}/${1}.crt"
PATH_LOGS="${BASE_DIR}/etc/nginx/logs"

mkdir $PATH_SSL 2>/dev/null

if [ ! -f $PATH_KEY ] || [ ! -f $PATH_CSR ] || [ ! -f $PATH_CRT ]
then
  openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
  openssl req -new -key "$PATH_KEY" -out "$PATH_CSR" -subj "/CN=$1/O=Vagrant/C=UK" 2>/dev/null
  openssl x509 -req -days 365 -in "$PATH_CSR" -signkey "$PATH_KEY" -out "$PATH_CRT" 2>/dev/null
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl;
    server_name $1;
    root \"$2\";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  ${PATH_LOGS}/$1-error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ \.php$ {
        include   /usr/local/etc/nginx/conf.d/php-fpm;
    }

    location ~ /\.ht {
        deny all;
    }


    ssl_certificate     $PATH_CRT;
    ssl_certificate_key $PATH_KEY;

}
"

echo "$block" > "/usr/local/etc/nginx/sites-available/$1"
ln -fs "/usr/local/etc/nginx/sites-available/$1" "/usr/local/etc/nginx/sites-enabled/$1"
# NEED ADMIN PASSWORD
echo "Done! Don't forget to update /etc/hosts and restart nginx."
