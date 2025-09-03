# CloudWalk Asset Manager

A shared slot management system for CloudWalk stakeholders to view and manage marketing assets.

## Features

- 🔐 **GitHub OAuth Authentication** (restricted to @cloudwalk.io domain)
- 🚀 **Real-time Synchronization** via Supabase
- 📱 **Responsive Design** for desktop and mobile
- 🎯 **13 Predefined Slots** based on your video assets:
  - checkout
  - create_bill
  - dirf
  - infinite_card
  - infinite_cash_can_request_limit
  - infinite_cash
  - instant_settlement
  - pay_bill
  - piselli
  - pix_credit
  - referral
  - supercobra
  - tap

## Setup Instructions

### 1. Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to SQL Editor and run the contents of `supabase-setup.sql`
3. Go to Settings → API to get your:
   - Project URL
   - Anon public key

### 2. GitHub OAuth Setup

1. Go to GitHub Settings → Developer settings → OAuth Apps
2. Create a new OAuth App with:
   - Application name: `CloudWalk Asset Manager`
   - Homepage URL: Your GitHub Pages URL (e.g., `https://yourusername.github.io/simple_slot_assets`)
   - Authorization callback URL: Your GitHub Pages URL
3. Note down the Client ID

### 3. Configure Authentication

1. In Supabase Dashboard → Authentication → Settings
2. Add GitHub as a provider using your Client ID and Client Secret
3. Set Site URL to your GitHub Pages URL
4. Add your GitHub Pages URL to redirect URLs

### 4. Update Configuration

Edit `index.html` and update these variables:

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_PROJECT_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
const GITHUB_CLIENT_ID = 'YOUR_GITHUB_CLIENT_ID';
```

### 5. Deploy to GitHub Pages

1. Push this repository to GitHub
2. Go to Repository Settings → Pages
3. Select "Deploy from a branch" and choose `main` branch
4. The site will be available at: `https://yourusername.github.io/repository-name`

## Usage

1. **Authentication**: Only users with @cloudwalk.io email addresses can access
2. **Upload Assets**: Click "Upload" or drag & drop images onto slots
3. **Real-time Updates**: All users see changes immediately
4. **Export URLs**: Get all asset URLs for external use
5. **Share**: Stakeholders can view the live page to see current assets

## Architecture

- **Frontend**: Vanilla HTML/CSS/JS (no build process needed)
- **Authentication**: GitHub OAuth via Supabase Auth
- **Database**: Supabase PostgreSQL with Row Level Security
- **Storage**: Supabase Storage with public access for sharing
- **Hosting**: GitHub Pages (free, fast, reliable)
- **Real-time**: Supabase Realtime for live updates

## Security

- Domain restriction to @cloudwalk.io users only
- Row Level Security (RLS) policies in database
- Secure file storage with proper access controls
- HTTPS everywhere via GitHub Pages

## File Structure

```
/
├── index.html              # Main application
├── supabase-setup.sql      # Database schema and policies
├── README.md              # This file
├── .github/
│   └── workflows/
│       └── deploy.yml      # GitHub Pages deployment
├── example folder/         # Reference video assets
└── reference/             # Reference images
```

## Support

For issues or questions, create a GitHub issue or contact the development team.
