# Quick Setup Guide

## Prerequisites
- GitHub account
- Supabase account (free tier works fine)

## Step-by-Step Setup

### 1. Fork/Clone this Repository
```bash
git clone https://github.com/your-username/simple_slot_assets.git
cd simple_slot_assets
```

### 2. Create Supabase Project
1. Go to [supabase.com](https://supabase.com) and create a new project
2. Wait for the project to be ready (2-3 minutes)
3. Go to **SQL Editor** and paste the entire contents of `supabase-setup.sql`
4. Click **Run** to create tables, policies, and storage bucket

### 3. Get Supabase Credentials
1. Go to **Settings** → **API**
2. Copy your **Project URL** and **anon public** key

### 4. Create GitHub OAuth App
1. Go to GitHub **Settings** → **Developer settings** → **OAuth Apps**
2. Click **New OAuth App**
3. Fill in:
   - **Application name**: CloudWalk Asset Manager
   - **Homepage URL**: `https://your-username.github.io/simple_slot_assets`
   - **Authorization callback URL**: `https://your-username.github.io/simple_slot_assets`
4. Click **Register application**
5. Copy the **Client ID**

### 5. Configure Supabase Auth
1. In Supabase, go to **Authentication** → **Settings**
2. Find **OAuth Providers** and enable **GitHub**
3. Enter your GitHub **Client ID** and **Client Secret**
4. Set **Site URL** to: `https://your-username.github.io/simple_slot_assets`
5. Add the same URL to **Redirect URLs**

### 6. Update Configuration
1. Open `index.html`
2. Find these lines around line 195-200:
```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
const GITHUB_CLIENT_ID = 'YOUR_GITHUB_CLIENT_ID';
```
3. Replace with your actual values:
```javascript
const SUPABASE_URL = 'https://your-project-ref.supabase.co';
const SUPABASE_ANON_KEY = 'your-actual-anon-key';
const GITHUB_CLIENT_ID = 'your-actual-client-id';
```

### 7. Deploy to GitHub Pages
1. Commit your changes:
```bash
git add .
git commit -m "Configure Supabase and GitHub OAuth"
git push origin main
```
2. Go to your repository on GitHub
3. Click **Settings** → **Pages**
4. Select **Deploy from a branch**
5. Choose **main** branch and **/ (root)** folder
6. Click **Save**

### 8. Test Your Deployment
1. Wait 2-5 minutes for deployment
2. Visit: `https://your-username.github.io/simple_slot_assets`
3. Try signing in with a @cloudwalk.io GitHub account

## Troubleshooting

### "Please configure Supabase credentials"
- Check that SUPABASE_URL and SUPABASE_ANON_KEY are correctly set in index.html

### "Failed to sign in with GitHub"
- Verify GitHub OAuth app URLs match your GitHub Pages URL exactly
- Check that the Client ID is correct in index.html
- Ensure Supabase GitHub provider is configured with correct credentials

### "Access restricted to @cloudwalk.io domain users only"
- This is expected! Only GitHub accounts with @cloudwalk.io email can access
- The system automatically checks the user's primary email address

### Real-time updates not working
- Check browser console for errors
- Verify Supabase RLS policies were created correctly by running the SQL again

## Usage

Once deployed:
1. **Stakeholders** can visit the URL to see current assets (read-only after auth)
2. **Team members** can upload/replace assets by dragging images or clicking upload
3. **Real-time sync** means everyone sees changes immediately
4. **Export feature** provides all asset URLs for external use

The 13 slots correspond to your video file names:
- checkout, create_bill, dirf, infinite_card, etc.

## Security Notes

- Only @cloudwalk.io email addresses can access
- All data is secured with Row Level Security policies
- Files are stored in Supabase Storage with proper access controls
- GitHub Pages provides HTTPS automatically
