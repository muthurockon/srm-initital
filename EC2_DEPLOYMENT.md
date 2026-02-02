# Deploying Portfolio Website to EC2 Instance

This guide will help you deploy your portfolio website to an AWS EC2 instance.

## Prerequisites

- AWS Account
- EC2 instance running (Ubuntu/Amazon Linux recommended)
- SSH access to your EC2 instance
- Basic knowledge of Linux commands

## Step 1: Launch EC2 Instance

1. **Go to AWS Console → EC2**
2. **Click "Launch Instance"**
3. **Configure:**
   - Name: `portfolio-website`
   - AMI: Ubuntu Server 22.04 LTS (or Amazon Linux 2023)
   - Instance type: t2.micro (free tier eligible)
   - Key pair: Create or select an existing key pair
   - Network settings: 
     - Allow HTTP (port 80) and HTTPS (port 443) traffic
     - Allow SSH (port 22) from your IP
4. **Launch the instance**

## Step 2: Connect to Your EC2 Instance

### Using SSH (Mac/Linux):
```bash
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

### Using SSH (Windows):
Use PuTTY or Windows Subsystem for Linux (WSL)

## Step 3: Install Web Server

### For Ubuntu/Debian:

```bash
# Update system packages
sudo apt update
sudo apt upgrade -y

# Install Apache web server
sudo apt install apache2 -y

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Check status
sudo systemctl status apache2
```

### For Amazon Linux:

```bash
# Update system packages
sudo yum update -y

# Install Apache web server
sudo yum install httpd -y

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Check status
sudo systemctl status httpd
```

## Step 4: Upload Your HTML File

### Option A: Using SCP (from your local machine)

```bash
# From your local machine (Mac/Linux)
scp -i your-key.pem index.html ubuntu@YOUR_EC2_PUBLIC_IP:/tmp/

# Then on EC2, move it to web directory
# For Ubuntu:
sudo mv /tmp/index.html /var/www/html/

# For Amazon Linux:
sudo mv /tmp/index.html /var/www/html/
```

### Option B: Using Git (if you have a repository)

```bash
# On EC2 instance
cd /var/www/html
sudo git clone YOUR_REPO_URL .
sudo mv index.html /var/www/html/
```

### Option C: Create file directly on EC2

```bash
# On EC2 instance
cd /var/www/html
sudo nano index.html
# Paste your HTML content, save and exit (Ctrl+X, Y, Enter)
```

### Option D: Using wget/curl

If your file is hosted somewhere:
```bash
cd /var/www/html
sudo wget YOUR_FILE_URL -O index.html
```

## Step 5: Set Proper Permissions

```bash
# For Ubuntu
sudo chown www-data:www-data /var/www/html/index.html
sudo chmod 644 /var/www/html/index.html

# For Amazon Linux
sudo chown apache:apache /var/www/html/index.html
sudo chmod 644 /var/www/html/index.html
```

## Step 6: Configure Apache (Optional but Recommended)

### Create a proper virtual host configuration:

```bash
# For Ubuntu
sudo nano /etc/apache2/sites-available/portfolio.conf
```

Add the following content:
```apache
<VirtualHost *:80>
    ServerName YOUR_DOMAIN_OR_IP
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/portfolio_error.log
    CustomLog ${APACHE_LOG_DIR}/portfolio_access.log combined
</VirtualHost>
```

Enable the site:
```bash
# For Ubuntu
sudo a2ensite portfolio.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
```

## Step 7: Configure Security Group

1. **Go to EC2 Console → Security Groups**
2. **Select your instance's security group**
3. **Add inbound rules:**
   - Type: HTTP, Port: 80, Source: 0.0.0.0/0
   - Type: HTTPS, Port: 443, Source: 0.0.0.0/0 (if using SSL)
   - Type: SSH, Port: 22, Source: Your IP (for security)

## Step 8: Test Your Website

1. **Get your EC2 Public IP:**
   - Go to EC2 Console → Instances
   - Find your instance and copy the Public IPv4 address

2. **Open in browser:**
   ```
   http://YOUR_EC2_PUBLIC_IP
   ```

## Step 9: (Optional) Set Up SSL with Let's Encrypt

### Install Certbot:

```bash
# For Ubuntu
sudo apt install certbot python3-certbot-apache -y

# For Amazon Linux
sudo yum install certbot python3-certbot-apache -y
```

### Get SSL Certificate:

```bash
# Replace with your domain name
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com
```

Follow the prompts. Certbot will automatically configure Apache.

## Step 10: (Optional) Set Up Custom Domain

1. **Get your EC2 Public IP**
2. **Go to your domain registrar**
3. **Create an A record:**
   - Type: A
   - Name: @ (or www)
   - Value: YOUR_EC2_PUBLIC_IP
   - TTL: 300

4. **Wait for DNS propagation** (can take up to 48 hours, usually faster)

## Troubleshooting

### Website not loading?

1. **Check Apache status:**
   ```bash
   sudo systemctl status apache2  # Ubuntu
   sudo systemctl status httpd    # Amazon Linux
   ```

2. **Check Apache logs:**
   ```bash
   sudo tail -f /var/log/apache2/error.log  # Ubuntu
   sudo tail -f /var/log/httpd/error_log    # Amazon Linux
   ```

3. **Check file permissions:**
   ```bash
   ls -la /var/www/html/
   ```

4. **Check security group** - ensure port 80 is open

5. **Test locally on server:**
   ```bash
   curl http://localhost
   ```

### Permission denied errors?

```bash
sudo chown -R www-data:www-data /var/www/html/  # Ubuntu
sudo chown -R apache:apache /var/www/html/       # Amazon Linux
sudo chmod -R 755 /var/www/html/
```

### Apache won't start?

```bash
# Check configuration syntax
sudo apache2ctl configtest  # Ubuntu
sudo httpd -t                # Amazon Linux

# View detailed error
sudo journalctl -xe
```

## Quick Setup Script

Save this as `setup.sh` and run on your EC2 instance:

```bash
#!/bin/bash

# Update system
sudo apt update && sudo apt upgrade -y

# Install Apache
sudo apt install apache2 -y

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Set permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

echo "Apache installed and configured!"
echo "Now upload your index.html to /var/www/html/"
```

Make it executable:
```bash
chmod +x setup.sh
./setup.sh
```

## Cost Considerations

- **t2.micro instance**: Free tier eligible (750 hours/month for 12 months)
- **After free tier**: ~$8-10/month for t2.micro
- **Data transfer**: First 1GB/month free, then $0.09/GB
- **Storage**: 30GB free on EBS, then ~$0.10/GB/month

## Security Best Practices

1. **Keep system updated:**
   ```bash
   sudo apt update && sudo apt upgrade -y  # Ubuntu
   sudo yum update -y                       # Amazon Linux
   ```

2. **Configure firewall (UFW for Ubuntu):**
   ```bash
   sudo ufw allow 22/tcp
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw enable
   ```

3. **Use SSH keys** instead of passwords

4. **Regular backups** of your website files

5. **Monitor logs** for suspicious activity

## Next Steps

- Set up automated backups
- Configure CloudWatch for monitoring
- Set up an Elastic IP (so IP doesn't change on restart)
- Consider using AWS Application Load Balancer for high availability
- Set up CloudFront CDN for better performance globally

Your portfolio website should now be live on your EC2 instance! 🚀
