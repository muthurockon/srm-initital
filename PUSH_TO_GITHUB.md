# How to Push to GitHub

Your repository is ready to push! Follow these steps:

## Quick Push Commands

### Option 1: Using Personal Access Token (Easiest)

1. **Get a Personal Access Token:**
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Name: "Portfolio Deployment"
   - Select scope: `repo`
   - Click "Generate token"
   - **Copy the token** (starts with `ghp_...`)

2. **Push to GitHub:**
   ```bash
   cd /Users/muthukumarvaidyanathan/Desktop/iitm/test
   git push -u origin main
   ```
   
   When prompted:
   - **Username:** `muthurockon`
   - **Password:** `[paste your personal access token]`

### Option 2: Using GitHub CLI

```bash
# Install GitHub CLI (if needed)
brew install gh

# Authenticate
gh auth login

# Push
cd /Users/muthukumarvaidyanathan/Desktop/iitm/test
git push -u origin main
```

### Option 3: Using SSH

```bash
# Change remote to SSH
cd /Users/muthukumarvaidyanathan/Desktop/iitm/test
git remote set-url origin git@github.com:muthurockon/srm-initital.git

# Push (if SSH key is set up)
git push -u origin main
```

---

## Current Status

✅ Git repository initialized  
✅ All files committed  
✅ Remote added: https://github.com/muthurockon/srm-initital.git  
✅ Branch renamed to `main`  
✅ `.gitignore` added (excludes `.pem` files)  
⏳ **Ready to push** (needs authentication)

---

## Files Ready to Push

- `index.html` - Your portfolio website
- `README.md` - Project documentation
- `EC2_DEPLOYMENT.md` - Detailed EC2 deployment guide
- `QUICK_START_EC2.md` - Quick reference
- `DEPLOYMENT_STEPS.md` - Complete CLI step-by-step guide
- `setup-ec2.sh` - Ubuntu setup script
- `setup-ec2-amazon-linux.sh` - Amazon Linux setup script
- `.gitignore` - Excludes sensitive files

---

After pushing, follow the steps in `DEPLOYMENT_STEPS.md` to deploy to EC2!
