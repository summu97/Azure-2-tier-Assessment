# Update & Install nodejs, npm, nginx.
sudo apt update
sudo apt install -y nodejs npm nginx git

# Create a directory for the application:
sudo mkdir /var/www/frontend && cd /var/www/frontend

# Initialize a Node.js project:
sudo npm init -y
sudo npm install express body-parser mssql

# copy app.js to /var/www/frontend.
copy ./app.js /var/www/frontend

# copy index.html to /var/www/frontend.
copy ./index.html /var/www/frontend
