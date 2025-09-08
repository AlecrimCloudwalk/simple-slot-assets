-- EMERGENCY: Temporarily disable RLS to test if that's the issue
-- This will help us identify if RLS policies are the problem

-- 1. Check current RLS status
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE tablename IN ('categories', 'category_slots', 'slot_assets', 'objects');

-- 2. TEMPORARILY disable RLS for testing (we'll re-enable it after)
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE category_slots DISABLE ROW LEVEL SECURITY;
ALTER TABLE slot_assets DISABLE ROW LEVEL SECURITY;

-- 3. Test basic table access
SELECT 'Categories accessible: ' || COUNT(*)::text as test_result FROM categories;
SELECT 'Category slots accessible: ' || COUNT(*)::text as test_result FROM category_slots;
SELECT 'Slot assets accessible: ' || COUNT(*)::text as test_result FROM slot_assets;

-- 4. Test the view
SELECT 'View accessible - total rows: ' || COUNT(*)::text as test_result FROM v_category_structure;

-- 5. Show sample data
SELECT 
    category_display_name,
    slot_display_name,
    'Data visible without RLS' as status
FROM v_category_structure 
LIMIT 10;

-- 6. Test specific query that the frontend is trying to make
SELECT 
    category_id,
    category_name,
    category_display_name,
    category_color,
    category_bg_class,
    category_sort_order,
    slot_id,
    slot_name,
    slot_display_name,
    slot_sort_order
FROM v_category_structure
ORDER BY category_sort_order, slot_sort_order
LIMIT 20;

SELECT 'If you see data above, RLS was the problem. The app should work now!' as status;
SELECT 'REMEMBER: This is temporary - we need to fix the RLS policies properly!' as warning;
