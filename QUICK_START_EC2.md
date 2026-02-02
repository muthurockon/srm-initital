# Quick Start: Deploy to EC2 in 5 Minutes

## Step 1: Launch EC2 Instance
1. AWS Console → EC2 → Launch Instance
2. Choose Ubuntu 22.04 LTS or Amazon Linux 2023
3. Select t2.micro (free tier)
4. Configure Security Group: Allow HTTP (port 80) and SSH (port 22)
5. Launch and note your Public IP

## Step 2: Connect to EC2
```bash
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
# For Amazon Linux, use: ec2-user@YOUR_EC2_PUBLIC_IP
```

## Step 3: Run Setup Script

### For Ubuntu:
```bash
# Upload the setup script
# From your local machine:
scp -i your-key.pem setup-ec2.sh ubuntu@YOUR_EC2_IP:/tmp/

# On EC2:
chmod +x /tmp/setup-ec2.sh
sudo /tmp/setup-ec2.sh
```

### For Amazon Linux:
```bash
# Upload the setup script
# From your local machine:
scp -i your-key.pem setup-ec2-amazon-linux.sh ec2-user@YOUR_EC2_IP:/tmp/

# On EC2:
chmod +x /tmp/setup-ec2-amazon-linux.sh
sudo /tmp/setup-ec2-amazon-linux.sh
```

## Step 4: Upload Your Website
```bash
# From your local machine:
scp -i your-key.pem index.html ubuntu@YOUR_EC2_IP:/tmp/

# On EC2 (Ubuntu):
sudo mv /tmp/index.html /var/www/html/

# On EC2 (Amazon Linux):
sudo mv /tmp/index.html /var/www/html/
```

## Step 5: Access Your Website
Open in browser: `http://YOUR_EC2_PUBLIC_IP`

## Manual Setup (Alternative)

If you prefer manual setup:

### Ubuntu:
```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo chown -R www-data:www-data /var/www/html/
```

### Amazon Linux:
```bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chown -R apache:apache /var/www/html/
```

Then upload your `index.html` to `/var/www/html/`

## Troubleshooting

**Website not loading?**
- Check security group allows port 80
- Check Apache is running: `sudo systemctl status apache2` (Ubuntu) or `sudo systemctl status httpd` (Amazon Linux)
- Check logs: `sudo tail -f /var/log/apache2/error.log` (Ubuntu) or `sudo tail -f /var/log/httpd/error_log` (Amazon Linux)

**Permission errors?**
```bash
# Ubuntu:
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Amazon Linux:
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/
```

That's it! Your portfolio is now live on EC2! 🎉
