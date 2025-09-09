-- Fix Categories Active Status
-- Sets all categories to is_active = true so they show up in API

-- Update all categories to be active
UPDATE public.categories 
SET is_active = true, updated_at = NOW()
WHERE is_active = false OR is_active IS NULL;

-- Show the result
SELECT 'After fix - categories status:' as info;
SELECT 
  COUNT(*) as total_categories,
  COUNT(*) FILTER (WHERE is_active = true) as active_categories,
  COUNT(*) FILTER (WHERE is_active = false OR is_active IS NULL) as inactive_categories
FROM categories;

-- Show active categories that should now appear in the app
SELECT 'Active categories (should show in app):' as info;
SELECT 
  name,
  display_name,
  sort_order,
  is_active
FROM categories 
WHERE is_active = true
ORDER BY sort_order, name
LIMIT 15;
