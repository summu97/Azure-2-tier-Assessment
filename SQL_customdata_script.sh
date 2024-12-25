#!/bin/bash

# Update the system repositories
sudo apt update

# Install curl for downloading required files
sudo apt install -y curl

# Add Microsoft GPG key for SQL Server repository
curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc > /dev/null

# Add SQL Server 2022 repository
curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | sudo tee /etc/apt/sources.list.d/mssql-server-2022.list > /dev/null

# Update the repository list
sudo apt update

# Install SQL Server
sudo apt install -y mssql-server

# Configure SQL Server with Developer edition and a strong SA password
sudo MSSQL_PID="Developer" ACCEPT_EULA=Y MSSQL_SA_PASSWORD="YourStrongPassword123" /opt/mssql/bin/mssql-conf -n setup

# Add Microsoft GPG key for tools
curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc > /dev/null

# Add Microsoft repository for tools
curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list > /dev/null

# Update the repository list again
sudo apt update

# Install SQL Server tools and dependencies
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev

# Add SQL Server tools to the global PATH
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' | sudo tee -a /etc/profile > /dev/null
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' | sudo tee -a /etc/bash.bashrc > /dev/null

# Source /etc/profile to apply changes for the current shell
source /etc/profile

# Ensure the environment variables are set globally
sudo su -c "echo 'export PATH=\"$PATH:/opt/mssql-tools18/bin\"' >> /home/azureuser/.bashrc"
sudo su -c "source /home/azureuser/.bashrc"

# Restart SQL Server if needed (to ensure it's running)
sudo systemctl start mssql-server

# Create the Database
sudo su - azureuser -c "cd /home/azureuser && sqlcmd -S localhost -U sa -P 'YourStrongPassword123' -Q \"CREATE DATABASE TestDB;\" -C"

# Create Table in the newly created database
sudo su - azureuser -c "cd /home/azureuser && sqlcmd -S localhost -U sa -P 'YourStrongPassword123' -Q \"USE TestDB; CREATE TABLE Users (ID INT IDENTITY(1,1) PRIMARY KEY, Name NVARCHAR(100), Email NVARCHAR(100), Contact NVARCHAR(15));\" -C"

# Restart your VM to add changes
sudo shutdown -r now
