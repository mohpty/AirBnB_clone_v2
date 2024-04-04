#!/usr/bin/env bash
# Install Nginx if not already installed
if ! dpkg -l | grep -q nginx; then
    apt-get update
    apt-get -y install nginx
fi

# Create necessary directories if they don't exist
mkdir -p /data/web_static/{releases/test,shared}

# Create a fake HTML file for testing Nginx configuration
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" > /data/web_static/releases/test/index.html

# Create or recreate symbolic link
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership of /data/ folder to ubuntu user and group recursively
chown -R ubuntu:ubuntu /data/

# Update Nginx configuration to serve content of /data/web_static/current/ to hbnb_static
NGINX_CONFIG="/etc/nginx/sites-available/default"
NGINX_ALIAS="location /hbnb_static {\n    alias /data/web_static/current/;\n}"
if ! grep -q "location /hbnb_static" "$NGINX_CONFIG"; then
    sed -i "/server_name _;/a $NGINX_ALIAS" "$NGINX_CONFIG"
fi

# Restart Nginx
service nginx restart

# Exit successfully
exit 0
