-- Debug Authentication Context in Supabase SQL Editor
-- This helps understand why CloudWalk access is denied

-- =============================================
-- CHECK CURRENT SQL CONTEXT
-- =============================================

-- Check what user/role we're running as
SELECT current_user, current_role, session_user;

-- Check if we're in an authenticated API context or direct SQL
SELECT 
  CASE 
    WHEN current_user = 'postgres' THEN 'Running as postgres (SQL Editor)'
    WHEN current_user = 'authenticated' THEN 'Running as authenticated user'
    WHEN current_user = 'anon' THEN 'Running as anonymous user'
    ELSE 'Running as: ' || current_user
  END as execution_context;

-- =============================================
-- TEST AUTH FUNCTIONS AVAILABILITY
-- =============================================

-- Try to access auth functions (may fail in SQL Editor)
SELECT 
  CASE 
    WHEN auth.uid() IS NOT NULL THEN 'Auth UID: ' || auth.uid()::text
    ELSE 'Auth UID: NULL (no auth context)'
  END as auth_uid_test;

SELECT 
  CASE 
    WHEN auth.email() IS NOT NULL THEN 'Auth Email: ' || auth.email()
    ELSE 'Auth Email: NULL (no auth context)'  
  END as auth_email_test;

-- =============================================
-- CHECK EXISTING RLS POLICIES
-- =============================================

-- See what policies are currently active
SELECT 
    schemaname,
    tablename, 
    policyname,
    permissive,
    roles,
    cmd,
    qual as policy_condition
FROM pg_policies 
WHERE tablename IN ('slot_assets', 'categories', 'category_slots')
ORDER BY tablename, policyname;

-- =============================================
-- TEST TABLE ACCESS WITH CURRENT USER
-- =============================================

-- Try to access tables directly (may fail due to RLS)
-- This will show us the actual error messages

SELECT 'Testing slot_assets access...' as test;
-- SELECT COUNT(*) FROM public.slot_assets; -- Uncomment to test

SELECT 'Testing categories access...' as test;
-- SELECT COUNT(*) FROM public.categories; -- Uncomment to test  

SELECT 'Testing category_slots access...' as test;
-- SELECT COUNT(*) FROM public.category_slots; -- Uncomment to test

-- =============================================
-- RECOMMENDED APPROACH
-- =============================================

/*
The CloudWalk access check should be tested from your APPLICATION, not SQL Editor.

SQL Editor runs as 'postgres' user and bypasses RLS entirely.
The auth.email() function only works during authenticated API requests.

To properly apply RLS fixes:
1. Run the policy creation/modification SQL in the SQL Editor (as postgres)  
2. Test the "CloudWalk access" from your web application (as authenticated user)

The policies will work correctly for your app users even if the test query
shows "DENIED" when run directly in SQL Editor.
*/
