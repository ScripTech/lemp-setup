#!bash
# Install LEMP stack on Linux
# @Author: Edilson Mucanze
# @linkedin: https://www.linkedin.com/in/edilson-d-mucanze-550707b8/
# Version: 1.0

# Installing Lemp
# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

echo -e "${GREEN}Starting LEMP stack installation...${NC}"

# Update system packages
echo -e "${GREEN}Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install NGINX
echo -e "${GREEN}Installing NGINX...${NC}"
sudo apt install nginx -y

# Enable and start NGINX
sudo systemctl enable nginx
sudo systemctl start nginx

# Install the MariaDB
echo -e "${GREEN}Install the MariaDB database...${NC}"
sudo apt install mariadb-server -y

# Install PHP
echo -e "${GREEN}Installing PHP and required extensions...${NC}"
sudo apt install php-fpm php-mysql -y
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc -y

# Configure NGINX to use PHP
echo -e "${GREEN}Configuring NGINX to process PHP files...${NC}"
NGINX_CONF="/etc/nginx/sites-available/default"
sudo sed -i 's/index index.html index.htm/index index.php index.html index.htm/g' $NGINX_CONF
sudo sed -i 's/#location ~ \\\.php\$ {/location ~ \\\.php\$ {\n\tinclude snippets/fastcgi-php.conf;\n\tfastcgi_pass unix:\/run\/php\/php7.4-fpm.sock;\n}/g' $NGINX_CONF

# Create a root public_html directory for the site
sudo mkdir -p /stack/php-website/public
sudo cp /var/www/html/ind*.html /stack/php-website/public/.
sudo cp /etc/nginx/sites-enabled/default /etc/nginx/sites-available/example.com.conf

# config content
NGINX_CONF_WEBESITE=$(cat <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name example.com www.example.com;
    root /stack/php-website/public;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        include snippets/fastcgi-php.conf;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
)

echo "$NGINX_CONF_WEBESITE"  > /etc/nginx/sites-available/example.com.conf

# Enable the site by creating a link to the domain configuration file from the sites-enabled directory
sudo ln -s /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-enabled/
sudo rm -rf /etc/nginx/sites-enabled/default

# Validate the changes
echo -e "${GREEN}Validate the NGINX changes...${NC}"
sudo nginx -t

# PHP extra security measure
echo -e "${GREEN}Configuring PHP extra security measure...${NC}"
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/8.1/fpm/php.ini
sudo systemctl restart php8.1-fpm

# Reload NGINX
sudo nginx -s reload
sudo systemctl status nginx

# Prepare PHP testing
touch /stack/php-website/public/info.php
# Create a test PHP file using EOF
TEST_PHP_CONTENT=$(cat <<EOF
<?php
phpinfo();
#eZetsu
?>
EOF
)
echo -e "${GREEN}Creating a test PHP file...${NC}"
echo "$TEST_PHP_CONTENT" | sudo tee /stack/php-website/public/info.php > /dev/null

echo -e "${GREEN}Installation complete. Visit your server's IP address/info.php to test PHP!${NC}"
curl http://localhost/info.php


# DevOps
