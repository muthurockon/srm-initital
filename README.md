# Personal Portfolio Website

A modern, responsive portfolio website built as a single HTML file with embedded CSS and JavaScript.

## Features

✅ **Hero Section** - Eye-catching introduction with your name and title  
✅ **About Me Section** - Personal introduction and background  
✅ **Skills Section** - Showcase your technical skills  
✅ **Experience/Projects Section** - Timeline of work experience and featured projects  
✅ **Education Section** - Academic background and certifications  
✅ **Contact Section** - Contact form and social media links  
✅ **Responsive Design** - Works perfectly on mobile, tablet, and desktop  
✅ **Modern UI** - Clean, professional appearance with smooth animations  

## Customization Guide

### 1. Personal Information

Update the following sections with your information:

- **Hero Section** (Line ~200): Change "Your Name" and title
- **About Section** (Line ~210): Update the about text and profile image URL
- **Skills Section** (Line ~230): Modify skills to match your expertise
- **Experience Section** (Line ~250): Update your work experience timeline
- **Projects Section** (Line ~270): Add your actual projects
- **Education Section** (Line ~300): Update your educational background
- **Contact Section** (Line ~320): Update email, phone, location, and social links
- **Footer** (Line ~360): Update copyright with your name

### 2. Profile Image

Replace the placeholder image URL in the About section:
```html
<img src="https://via.placeholder.com/300" alt="Profile Picture" class="about-image">
```

You can:
- Use a direct link to an image hosted online
- Upload to your S3 bucket and use that URL
- Use a relative path if hosting locally

### 3. Color Scheme

Modify the CSS variables at the top of the `<style>` section (Line ~20):
```css
:root {
    --primary-color: #2563eb;    /* Main brand color */
    --secondary-color: #1e40af;  /* Darker shade */
    --text-color: #1f2937;        /* Main text color */
    --text-light: #6b7280;        /* Light text color */
    --bg-light: #f9fafb;          /* Light background */
}
```

### 4. Social Media Links

Update the social links in the Contact section (Line ~340):
```html
<a href="YOUR_LINKEDIN_URL" class="social-link">in</a>
<a href="YOUR_GITHUB_URL" class="social-link">G</a>
<a href="YOUR_TWITTER_URL" class="social-link">T</a>
<a href="YOUR_INSTAGRAM_URL" class="social-link">I</a>
```

## Deployment to S3

### Step 1: Prepare Your File
1. Customize the `index.html` file with your information
2. Ensure all images are hosted (S3, CDN, or external URLs)

### Step 2: Upload to S3
1. Log in to AWS Console
2. Navigate to S3
3. Create a new bucket or select an existing one
4. Enable **Static Website Hosting**:
   - Go to Properties → Static website hosting
   - Enable static website hosting
   - Set `index.html` as the index document
5. Upload `index.html` to the bucket
6. Set bucket policy to allow public read access:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
        }
    ]
}
```

### Step 3: Access Your Website
Your website will be available at:
```
http://YOUR-BUCKET-NAME.s3-website-REGION.amazonaws.com
```

Or configure a custom domain through Route 53.

## Alternative Deployment Options

### GitHub Pages
1. Create a GitHub repository
2. Upload `index.html` (rename to `index.html` if needed)
3. Go to Settings → Pages
4. Select your branch and save
5. Your site will be live at `https://YOUR-USERNAME.github.io/YOUR-REPO-NAME`

### Netlify
1. Drag and drop the `index.html` file to Netlify
2. Your site will be live instantly with a free `.netlify.app` domain

### Vercel
1. Install Vercel CLI: `npm i -g vercel`
2. Run `vercel` in the project directory
3. Follow the prompts

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Notes

- The contact form currently shows an alert. To make it functional, integrate with a backend service like:
  - Formspree
  - EmailJS
  - AWS SES
  - Your own API endpoint
- All animations and interactions are handled with vanilla JavaScript (no dependencies)
- The design is fully responsive and mobile-friendly

## License

Feel free to use this template for your personal portfolio!
