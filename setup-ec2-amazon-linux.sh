#!/bin/bash

# EC2 Portfolio Website Setup Script for Amazon Linux
# This script sets up Apache web server on Amazon Linux EC2 instance

echo "=========================================="
echo "Portfolio Website EC2 Setup (Amazon Linux)"
echo "=========================================="

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Install Apache web server
echo "Installing Apache web server..."
sudo yum install httpd -y

# Start and enable Apache
echo "Starting Apache service..."
sudo systemctl start httpd
sudo systemctl enable httpd

# Check Apache status
echo "Checking Apache status..."
sudo systemctl status httpd --no-pager

# Set proper permissions
echo "Setting file permissions..."
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/

# Create backup of default index
if [ -f /var/www/html/index.html ]; then
    echo "Backing up default index.html..."
    sudo mv /var/www/html/index.html /var/www/html/index.html.backup
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Upload your index.html file to /var/www/html/"
echo "2. You can use SCP from your local machine:"
echo "   scp -i your-key.pem index.html ec2-user@YOUR_EC2_IP:/tmp/"
echo "   Then on EC2: sudo mv /tmp/index.html /var/www/html/"
echo ""
echo "3. Or create/edit directly on EC2:"
echo "   sudo nano /var/www/html/index.html"
echo ""
echo "4. Access your website at: http://YOUR_EC2_PUBLIC_IP"
echo ""
echo "To check Apache logs:"
echo "   sudo tail -f /var/log/httpd/error_log"
echo ""
