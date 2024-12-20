#!/bin/bash

set -e

# Install dependencies
sudo apt update
sudo apt install -y curl software-properties-common nginx git
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Set up application
sudo mkdir -p /var/www/frontend
cd /var/www/frontend
sudo npm init -y
sudo npm install express body-parser mssql
git clone https://github.com/summu97/Azure-2-tier-Assessment.git /tmp/app_resources/
sudo mv /tmp/app_resources/* /var/www/frontend/
sudo rm -rf /tmp/app_resources

# Verify required files exist
if [[ ! -f /var/www/frontend/app.js || ! -f /var/www/frontend/index.html ]]; then
    echo "Required files (app.js, index.html) are missing in /var/www/frontend."
    exit 1
fi

sudo chown -R www-data:www-data /var/www/frontend
sudo chmod -R 755 /var/www/frontend

# Create systemd service
sudo tee /etc/systemd/system/frontend.service > /dev/null <<EOL
[Unit]
Description=Frontend Node.js Application
After=network.target

[Service]
WorkingDirectory=/var/www/frontend
ExecStart=/usr/bin/node app.js
Restart=always
User=www-data
Group=www-data
Environment=PORT=8080

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable frontend
sudo systemctl start frontend

# Configure Nginx
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOL
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Restart Nginx to apply changes
sudo nginx -t
sudo systemctl restart nginx
