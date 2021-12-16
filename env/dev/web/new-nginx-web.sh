#! /bin/bash
# https://linuxconfig.org/how-to-setup-the-nginx-web-server-on-ubuntu-18-04-bionic-beaver-linux

# Install NGINX: Sync with Ubuntu repos and install the NGNIX package 
sudo apt-get update && sudo apt-get install nginx 

# Enable the Uncomplicated FireWall
sudo ufw enable 

# Allow incomming connection via port 80
sudo ufw allow 80/tcp 

# Restart Nginx
sudo systemctl restart nginx

# task-item: integrate with a post provisioning configuration
<< comment
# Define custom server block
sudo mkdir /var/www/example 

# Create a new index.html page to show
TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME=$(date +"%x %r %Z")
# Create an index.html page to display
echo "Welcome to the CAF Azure Landing Zone Online Experiment" | sudo tee /var/www/example/index.html > /dev/null
echo $TITLE | sudo tee -a /var/www/example/index.html > /dev/null
echo "Time: $CURRENT_TIME, User: $USER" | sudo tee -a /var/www/example/index.html > /dev/null

# Create a new server block with nano in /etc/nginix/sites-available

server {
    listen 80;
    root /var/www/example;
    index index.html;
    server_name www.example.lan;
}
comment