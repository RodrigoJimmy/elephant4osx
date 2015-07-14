## PHP-FPM aliases
alias php-fpm.start='launchctl load -w /usr/local/opt/php56/homebrew.mxcl.php56.plist'
alias php-fpm.stop='launchctl unload -w /usr/local/opt/php56/homebrew.mxcl.php56.plist'
alias php-fpm.restart='php-fpm.stop && php-fpm.start'

## NGINX aliases
alias nginx.start='sudo launchctl load /usr/local/opt/nginx/homebrew.mxcl.nginx.plist'
alias nginx.stop='sudo launchctl unload /usr/local/opt/nginx/homebrew.mxcl.nginx.plist'
alias nginx.restart='nginx.stop && nginx.start'

## NGINX LOG aliases
alias nginx.logs.error='tail -250f /usr/local/etc/nginx/logs/error.log'
alias nginx.logs.access='tail -250f /usr/local/etc/nginx/logs/access.log'
alias nginx.logs.default.access='tail -250f /usr/local/etc/nginx/logs/default.access.log'
alias nginx.logs.default-ssl.access='tail -250f /usr/local/etc/nginx/logs/default-ssl.access.log'

## MySQL aliases
alias mysql.start='launchctl load -w /usr/local/opt/mysql/homebrew.mxcl.mysql.plist'
alias mysql.stop='launchctl unload -w /usr/local/opt/mysql/homebrew.mxcl.mysql.plist'
alias mysql.restart='mysql.stop && mysql.start'

