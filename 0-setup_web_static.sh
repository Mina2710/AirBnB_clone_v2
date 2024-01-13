#!/usr/bin/env bash
# Sets up a web server for deployment of web_static.

# Update package list and install Nginx
apt-get update
apt-get install -y nginx

# Create necessary directories and files
mkdir -p /data/web_static/{releases/test,shared}
echo "Holberton School" > /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership and group recursively
chown -R ubuntu:ubuntu /data/

# Configure Nginx
nginx_config="/etc/nginx/sites-available/default"
nginx_content=$(cat <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By $HOSTNAME;
    root   /var/www/html;
    index  index.html index.htm;

    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }

    location /redirect_me {
        return 301 http://cuberule.com/;
    }

    error_page 404 /404.html;
    location /404 {
        root /var/www/html;
        internal;
    }
}
EOF
)

echo "$nginx_content" > "$nginx_config"

# Restart Nginx
service nginx restart
