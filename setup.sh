# Update & Install nodejs, npm, nginx.
sudo apt update
sudo apt install -y nodejs npm nginx git

# Create a directory for the application:
sudo mkdir /var/www/frontend && cd /var/www/frontend

# Initialize a Node.js project:
sudo npm init -y
sudo npm install express body-parser mssql

# move app.js to /var/www/frontend.
mv ./app.js /var/www/frontend

# move index.html to /var/www/frontend.
mv ./index.html /var/www/frontend

# 
cat ./inginx_configuration >> /etc/nginx/sites-available/default
