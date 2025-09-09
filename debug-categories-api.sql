-- Debug Categories API Issue
-- The app shows 19 categories in DB but API returns 0 items
-- This suggests an is_active or RLS filtering issue

-- Check what categories exist and their is_active status
SELECT 'All categories in database:' as info;
SELECT 
  id,
  name, 
  display_name,
  is_active,
  created_by,
  created_at
FROM categories 
ORDER BY sort_order, name;

-- Check how many have is_active = true
SELECT 'Active categories count:' as info;
SELECT 
  COUNT(*) as total_categories,
  COUNT(*) FILTER (WHERE is_active = true) as active_categories,
  COUNT(*) FILTER (WHERE is_active = false OR is_active IS NULL) as inactive_categories
FROM categories;

-- Test the exact query the app is likely using
SELECT 'Testing app query (is_active = true):' as info;
SELECT 
  id,
  name,
  display_name,
  color,
  bg_class,
  sort_order
FROM categories 
WHERE is_active = true
ORDER BY sort_order;

-- Check if RLS is blocking the query by testing as current user
SELECT 'Current user context:' as info;
SELECT 
  'user_id' as field, COALESCE(auth.uid()::text, 'NULL') as value
UNION ALL
SELECT 
  'user_email', COALESCE(auth.email(), 'NULL');
