-- Quick Test Fix - Disable RLS and Ensure Active Categories
-- Run this to immediately test your web app

-- 1. Disable RLS temporarily for all tables
ALTER TABLE public.categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.slot_assets DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.category_slots DISABLE ROW LEVEL SECURITY;

-- 2. Ensure categories are active
UPDATE public.categories 
SET is_active = true, updated_at = NOW()
WHERE is_active = false OR is_active IS NULL;

-- 3. Show what we have
SELECT 'Categories status after fix:' as info;
SELECT 
  COUNT(*) as total_categories,
  COUNT(*) FILTER (WHERE is_active = true) as active_categories,
  COUNT(*) FILTER (WHERE is_active = false OR is_active IS NULL) as inactive_categories
FROM categories;

-- 4. Show first 10 active categories
SELECT 'First 10 active categories:' as info;
SELECT 
  id, name, display_name, sort_order, is_active
FROM categories 
WHERE is_active = true
ORDER BY sort_order, name
LIMIT 10;

-- 5. Test query that app uses
SELECT 'Test app query (should return data):' as info;
SELECT 
  id, name, display_name, color, bg_class, sort_order
FROM categories 
WHERE is_active = true
ORDER BY sort_order
LIMIT 5;

SELECT '🎉 RLS disabled and categories activated! Refresh your web app now!' as message;
