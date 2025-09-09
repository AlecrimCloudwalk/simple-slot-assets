-- Temporary Disable RLS for Testing
-- This will help us confirm if RLS is the issue
-- IMPORTANT: Only use this for testing, re-enable RLS after!

-- Temporarily disable RLS on categories table
ALTER TABLE public.categories DISABLE ROW LEVEL SECURITY;

-- Test query that should now work
SELECT 
  'After disabling RLS:' as status,
  COUNT(*) as total_categories,
  COUNT(*) FILTER (WHERE is_active = true) as active_categories
FROM categories;

-- Show active categories
SELECT 
  name,
  display_name, 
  is_active
FROM categories 
WHERE is_active = true
ORDER BY sort_order
LIMIT 10;

-- IMPORTANT: Re-enable RLS after testing your web app
-- ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
