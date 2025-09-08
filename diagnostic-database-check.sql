-- CloudWalk Asset Manager: Diagnostic Database Check
-- Run this in your Supabase SQL Editor to diagnose the issue

-- 1. Check if new tables exist
SELECT 'Categories table exists: ' || CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'categories') THEN 'YES' ELSE 'NO' END as status;
SELECT 'Category_slots table exists: ' || CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'category_slots') THEN 'YES' ELSE 'NO' END as status;

-- 2. Check if view exists
SELECT 'View v_category_structure exists: ' || CASE WHEN EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_category_structure') THEN 'YES' ELSE 'NO' END as status;

-- 3. Check table contents
SELECT 'Categories count: ' || COUNT(*)::text as status FROM categories;
SELECT 'Category slots count: ' || COUNT(*)::text as status FROM category_slots;
SELECT 'Slot assets count: ' || COUNT(*)::text as status FROM slot_assets;

-- 4. Check if slot_assets has new columns
SELECT 'slot_assets has category_id: ' || CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'slot_assets' AND column_name = 'category_id') THEN 'YES' ELSE 'NO' END as status;
SELECT 'slot_assets has slot_id: ' || CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'slot_assets' AND column_name = 'slot_id') THEN 'YES' ELSE 'NO' END as status;

-- 5. Test the view directly (this might show the error)
SELECT COUNT(*) as view_row_count FROM v_category_structure;

-- 6. Test basic category query
SELECT 
    id,
    name,
    display_name,
    color,
    sort_order
FROM categories 
ORDER BY sort_order 
LIMIT 10;

-- 7. Test basic category_slots query
SELECT 
    cs.id,
    c.display_name as category,
    cs.slot_name,
    cs.display_name as slot_display
FROM category_slots cs
JOIN categories c ON cs.category_id = c.id
ORDER BY c.sort_order, cs.sort_order 
LIMIT 20;

-- 8. Check RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('categories', 'category_slots', 'slot_assets');
