-- Debug Frontend Access Issues
-- Test exactly what the frontend can and cannot access

-- 1. Test basic authentication context
SELECT 
    'Current auth context:' as test,
    auth.uid() as user_id,
    auth.email() as user_email,
    auth.jwt() ->> 'email' as jwt_email;

-- 2. Test if RLS is blocking frontend specifically
-- Let's create a test without any RLS at all
CREATE TABLE IF NOT EXISTS test_frontend_access (
    id SERIAL PRIMARY KEY,
    message TEXT
);

-- Don't enable RLS on this test table
INSERT INTO test_frontend_access (message) VALUES ('Frontend can see this!');

-- 3. Test the actual query the frontend is making
-- This is exactly what your app is trying to do:
SELECT 
    'Testing exact frontend query...' as test_step;

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
ORDER BY category_sort_order ASC, slot_sort_order ASC;

-- 4. If that fails, try direct table access
SELECT 'Testing direct table access...' as test_step;

SELECT id, name, display_name FROM categories ORDER BY sort_order;

-- 5. Check if there's an issue with the view permissions specifically
SELECT 'View definition:' as info;
SELECT definition FROM pg_views WHERE viewname = 'v_category_structure';

-- 6. Test without the view - direct join (what the view should return)
SELECT 
    c.id as category_id,
    c.name as category_name,
    c.display_name as category_display_name,
    cs.id as slot_id,
    cs.slot_name,
    cs.display_name as slot_display_name
FROM categories c
LEFT JOIN category_slots cs ON c.id = cs.category_id
ORDER BY c.sort_order, cs.sort_order
LIMIT 10;

SELECT 'If you see categories and slots above, the issue is NOT the data or basic access!' as diagnosis;
