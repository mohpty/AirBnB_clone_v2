#!/usr/bin/env bash
# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo apt-get -y install nginx
fi

# Create necessary directories if they don't exist
sudo mkdir -p /data/web_static/{releases/test,shared}
sudo touch /data/web_static/releases/test/index.html

# Create symbolic link to the test folder
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership of /data/ folder to ubuntu user and group recursively
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration to serve content of /data/web_static/current/ to hbnb_static
CONFIG_PATH="/etc/nginx/sites-available/default"
NGINX_ALIAS="location /hbnb_static {\n    alias /data/web_static/current/;\n}"
if ! sudo grep -q "location /hbnb_static" "$CONFIG_PATH"; then
    sudo sed -i "/server_name _;/a $NGINX_ALIAS" "$CONFIG_PATH"
fi

# Restart Nginx
sudo service nginx restart

# Exit successfully
exit 0
