-- Super Simple Database Connectivity Test
-- This tests the most basic queries to isolate the issue

-- Test 1: Basic SELECT (should always work)
SELECT 'Database connection working!' as test_result;
SELECT NOW() as current_time;

-- Test 2: Check if our tables exist at all
SELECT 
    table_name,
    CASE WHEN table_name IN ('categories', 'category_slots', 'slot_assets') THEN 'EXISTS' ELSE 'MISSING' END as status
FROM information_schema.tables 
WHERE table_name IN ('categories', 'category_slots', 'slot_assets');

-- Test 3: Check RLS status (this might be blocking everything)
SELECT 
    tablename,
    rowsecurity as rls_enabled,
    CASE WHEN rowsecurity THEN 'RLS IS ON - MIGHT BLOCK ACCESS' ELSE 'RLS IS OFF' END as rls_status
FROM pg_tables 
WHERE tablename IN ('categories', 'category_slots', 'slot_assets');

-- Test 4: Try to count rows WITHOUT any complex queries
SELECT 'Testing basic table access...' as test_step;

-- Disable RLS temporarily for this test
ALTER TABLE IF EXISTS categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS category_slots DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS slot_assets DISABLE ROW LEVEL SECURITY;

-- Now try basic counts
SELECT 'categories table rows: ' || COUNT(*)::text as count_result FROM categories;
SELECT 'category_slots table rows: ' || COUNT(*)::text as count_result FROM category_slots;  
SELECT 'slot_assets table rows: ' || COUNT(*)::text as count_result FROM slot_assets;

-- Test 5: If tables are empty, let's insert ONE category for testing
INSERT INTO categories (name, display_name, created_by) 
VALUES ('test', 'Test Category', 'system')
ON CONFLICT (name) DO NOTHING;

-- Check if that worked
SELECT 'After insert - categories: ' || COUNT(*)::text as final_count FROM categories;

-- Test 6: Try the simplest possible SELECT from categories
SELECT id, name, display_name FROM categories LIMIT 1;

SELECT 'If you see a category above, the database is accessible!' as final_result;
