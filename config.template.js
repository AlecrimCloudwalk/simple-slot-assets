// Configuration Template for CloudWalk Asset Manager
// Copy this to your index.html and replace the placeholder values

// 1. Create a Supabase project at https://supabase.com
// 2. Run the SQL in supabase-setup.sql in your SQL Editor
// 3. Get these values from Settings > API in your Supabase dashboard

const SUPABASE_URL = 'https://your-project-ref.supabase.co';
const SUPABASE_ANON_KEY = 'your-supabase-anon-key-here';

// 4. Create a GitHub OAuth App:
// - Go to GitHub Settings > Developer settings > OAuth Apps
// - Create new OAuth App
// - Homepage URL: https://your-username.github.io/simple_slot_assets  
// - Authorization callback URL: https://your-username.github.io/simple_slot_assets
// 5. Note the Client ID

const GITHUB_CLIENT_ID = 'your-github-oauth-client-id';

// 6. In Supabase Dashboard > Authentication > Settings:
// - Enable GitHub provider with your Client ID and Secret
// - Set Site URL to your GitHub Pages URL
// - Add redirect URLs

/* 
STEPS TO DEPLOY:

1. Push this repository to GitHub
2. Go to repository Settings > Pages 
3. Enable Pages from main branch
4. Update the config values in index.html
5. Your site will be live at: https://your-username.github.io/simple_slot_assets

The system will restrict access to @cloudwalk.io email addresses only.
*/
