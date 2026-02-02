# Complete Deployment Guide: GitHub → EC2

## Part 1: Push to GitHub

### Step 1: Authenticate with GitHub

You have two options:

#### Option A: Using Personal Access Token (Recommended)

1. **Generate a Personal Access Token:**
   - Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Give it a name: "Portfolio Deployment"
   - Select scopes: `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again!)

2. **Push using token:**
   ```bash
   cd /Users/muthukumarvaidyanathan/Desktop/iitm/test
   git push -u origin main
   # When prompted:
   # Username: muthurockon
   # Password: [paste your personal access token]
   ```

#### Option B: Using SSH (Alternative)

1. **Set up SSH key** (if not already done):
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   # Press Enter to accept default location
   # Add passphrase (optional but recommended)
   ```

2. **Add SSH key to GitHub:**
   ```bash
   cat ~/.ssh/id_ed25519.pub
   # Copy the output
   # Go to GitHub → Settings → SSH and GPG keys → New SSH key
   # Paste and save
   ```

3. **Change remote to SSH:**
   ```bash
   git remote set-url origin git@github.com:muthurockon/srm-initital.git
   git push -u origin main
   ```

#### Option C: Using GitHub CLI

```bash
# Install GitHub CLI (if not installed)
brew install gh  # macOS
# or
sudo apt install gh  # Linux

# Authenticate
gh auth login

# Push
git push -u origin main
```

---

## Part 2: Deploy to EC2 - Step by Step CLI Commands

### Prerequisites
- EC2 instance running (Ubuntu or Amazon Linux)
- EC2 Public IP address
- SSH key file (e.g., `your-key.pem`)

---

### Step 1: Connect to Your EC2 Instance

```bash
# Make sure your key has correct permissions
chmod 400 your-key.pem

# Connect to EC2 (Ubuntu)
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# OR for Amazon Linux
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

---

### Step 2: Update System and Install Apache

#### For Ubuntu/Debian:

```bash
# Update package list
sudo apt update

# Upgrade system packages
sudo apt upgrade -y

# Install Apache web server
sudo apt install apache2 -y

# Start Apache service
sudo systemctl start apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Check Apache status
sudo systemctl status apache2
```

#### For Amazon Linux:

```bash
# Update package list
sudo yum update -y

# Install Apache web server
sudo yum install httpd -y

# Start Apache service
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Check Apache status
sudo systemctl status httpd
```

---

### Step 3: Install Git (if not already installed)

#### For Ubuntu:

```bash
sudo apt install git -y
```

#### For Amazon Linux:

```bash
sudo yum install git -y
```

---

### Step 4: Clone Your Repository

```bash
# Navigate to web root directory
cd /var/www/html

# Backup default index.html (if exists)
sudo mv index.html index.html.backup 2>/dev/null || true

# Clone your repository
sudo git clone https://github.com/muthurockon/srm-initital.git .

# OR if you need to authenticate:
sudo git clone https://YOUR_USERNAME:YOUR_TOKEN@github.com/muthurockon/srm-initital.git .
```

**Note:** If authentication is required, you can:
- Use a Personal Access Token in the URL
- Or set up SSH keys on EC2

---

### Step 5: Set Proper Permissions

#### For Ubuntu:

```bash
# Set ownership
sudo chown -R www-data:www-data /var/www/html/

# Set permissions
sudo chmod -R 755 /var/www/html/

# Ensure index.html is readable
sudo chmod 644 /var/www/html/index.html
```

#### For Amazon Linux:

```bash
# Set ownership
sudo chown -R apache:apache /var/www/html/

# Set permissions
sudo chmod -R 755 /var/www/html/

# Ensure index.html is readable
sudo chmod 644 /var/www/html/index.html
```

---

### Step 6: Verify Apache Configuration

#### For Ubuntu:

```bash
# Check Apache configuration syntax
sudo apache2ctl configtest

# Restart Apache
sudo systemctl restart apache2
```

#### For Amazon Linux:

```bash
# Check Apache configuration syntax
sudo httpd -t

# Restart Apache
sudo systemctl restart httpd
```

---

### Step 7: Configure Security Group (AWS Console)

1. Go to **EC2 Console → Security Groups**
2. Select your instance's security group
3. Click **"Edit inbound rules"**
4. Add rules:
   - **Type:** HTTP, **Port:** 80, **Source:** 0.0.0.0/0
   - **Type:** HTTPS, **Port:** 443, **Source:** 0.0.0.0/0 (optional)
5. Click **"Save rules"**

---

### Step 8: Test Your Website

```bash
# Test locally on EC2
curl http://localhost

# You should see your HTML content
```

Then open in your browser:
```
http://YOUR_EC2_PUBLIC_IP
```

---

### Step 9: (Optional) Set Up Auto-Deploy on Git Push

Create a script to automatically pull updates:

```bash
# Create update script
sudo nano /var/www/html/update.sh
```

Add this content:
```bash
#!/bin/bash
cd /var/www/html
sudo git pull origin main
sudo chown -R www-data:www-data /var/www/html/  # Ubuntu
# OR
# sudo chown -R apache:apache /var/www/html/     # Amazon Linux
sudo systemctl reload apache2  # Ubuntu
# OR
# sudo systemctl reload httpd  # Amazon Linux
```

Make it executable:
```bash
sudo chmod +x /var/www/html/update.sh
```

Then whenever you update GitHub, SSH to EC2 and run:
```bash
sudo /var/www/html/update.sh
```

---

### Step 10: (Optional) Set Up SSL with Let's Encrypt

```bash
# Install Certbot
# For Ubuntu:
sudo apt install certbot python3-certbot-apache -y

# For Amazon Linux:
sudo yum install certbot python3-certbot-apache -y

# Get SSL certificate (replace with your domain)
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com

# Follow the prompts
# Certbot will automatically configure Apache
```

---

## Troubleshooting Commands

### Check Apache Status:
```bash
# Ubuntu
sudo systemctl status apache2

# Amazon Linux
sudo systemctl status httpd
```

### View Apache Logs:
```bash
# Ubuntu - Error log
sudo tail -f /var/log/apache2/error.log

# Ubuntu - Access log
sudo tail -f /var/log/apache2/access.log

# Amazon Linux - Error log
sudo tail -f /var/log/httpd/error_log

# Amazon Linux - Access log
sudo tail -f /var/log/httpd/access_log
```

### Check File Permissions:
```bash
ls -la /var/www/html/
```

### Test Apache Configuration:
```bash
# Ubuntu
sudo apache2ctl configtest

# Amazon Linux
sudo httpd -t
```

### Restart Apache:
```bash
# Ubuntu
sudo systemctl restart apache2

# Amazon Linux
sudo systemctl restart httpd
```

### Check if Port 80 is Open:
```bash
sudo netstat -tulpn | grep :80
# OR
sudo ss -tulpn | grep :80
```

---

## Quick Reference: Complete Deployment in One Go

### For Ubuntu:

```bash
# 1. Connect to EC2
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# 2. Run all setup commands
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 git -y
sudo systemctl start apache2 && sudo systemctl enable apache2
cd /var/www/html
sudo mv index.html index.html.backup 2>/dev/null || true
sudo git clone https://github.com/muthurockon/srm-initital.git .
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo systemctl restart apache2
```

### For Amazon Linux:

```bash
# 1. Connect to EC2
ssh -i your-key.pem ec2-user@YOUR_EC2_IP

# 2. Run all setup commands
sudo yum update -y
sudo yum install httpd git -y
sudo systemctl start httpd && sudo systemctl enable httpd
cd /var/www/html
sudo mv index.html index.html.backup 2>/dev/null || true
sudo git clone https://github.com/muthurockon/srm-initital.git .
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo systemctl restart httpd
```

---

## Next Steps After Deployment

1. **Customize your portfolio:**
   - Edit `index.html` on your local machine
   - Push changes to GitHub
   - Pull changes on EC2: `cd /var/www/html && sudo git pull`

2. **Set up a custom domain:**
   - Point your domain's A record to EC2 Public IP
   - Set up SSL certificate with Let's Encrypt

3. **Monitor your website:**
   - Set up CloudWatch alarms
   - Monitor Apache logs regularly

4. **Backup:**
   - Regularly backup `/var/www/html/`
   - Consider using AWS Backup or manual backups

Your portfolio website is now live on EC2! 🚀
