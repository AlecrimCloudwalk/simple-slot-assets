-- Test Database Permissions
-- Run this to check if RLS policies are working correctly with your authentication

-- 1. First, check if categories table has data (this should work for superuser)
SELECT 'Total categories in table: ' || COUNT(*)::text as check_result FROM categories;

-- 2. Test if RLS is too restrictive - temporarily disable it for testing
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE category_slots DISABLE ROW LEVEL SECURITY;
ALTER TABLE slot_assets DISABLE ROW LEVEL SECURITY;

-- 3. Test the view without RLS
SELECT 'View test without RLS - categories found: ' || COUNT(DISTINCT category_id)::text as check_result 
FROM v_category_structure;

-- 4. Show a sample of the view data
SELECT 
    category_display_name,
    slot_display_name,
    'Sample data visible' as status
FROM v_category_structure 
LIMIT 5;

-- 5. Re-enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE category_slots ENABLE ROW LEVEL SECURITY; 
ALTER TABLE slot_assets ENABLE ROW LEVEL SECURITY;

-- 6. Create more permissive policies for testing (temporarily)
DROP POLICY IF EXISTS "CloudWalk users can view all categories" ON categories;
CREATE POLICY "CloudWalk users can view all categories" ON categories
    FOR SELECT TO authenticated
    USING (true); -- Allow all authenticated users for now

DROP POLICY IF EXISTS "CloudWalk users can view all category slots" ON category_slots;
CREATE POLICY "CloudWalk users can view all category slots" ON category_slots
    FOR SELECT TO authenticated  
    USING (true); -- Allow all authenticated users for now

DROP POLICY IF EXISTS "CloudWalk users can view all slot assets" ON slot_assets;
CREATE POLICY "CloudWalk users can view all slot assets" ON slot_assets
    FOR SELECT TO authenticated
    USING (true); -- Allow all authenticated users for now

-- 7. Test with permissive policies
SELECT 'After permissive policies - view works: ' || CASE WHEN COUNT(*) > 0 THEN 'YES' ELSE 'NO' END as check_result
FROM v_category_structure;

SELECT 'Categories visible: ' || COUNT(DISTINCT category_id)::text as check_result 
FROM v_category_structure;
