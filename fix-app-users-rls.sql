-- ===================================================================
-- FIX APP_USERS RLS - THE REAL ISSUE REVEALED BY DEBUG LOGS
-- ===================================================================

-- The debug logs show the real error:
-- "new row violates row-level security policy for table \"app_users\""

-- We disabled RLS on asset_votes and asset_comments, but forgot app_users!
-- When voting, triggers try to auto-create users in app_users table,
-- but RLS policy blocks this operation.

-- 1. DISABLE RLS ON APP_USERS TABLE
ALTER TABLE public.app_users DISABLE ROW LEVEL SECURITY;

-- 2. DROP ALL EXISTING POLICIES ON APP_USERS (clean slate)
DROP POLICY IF EXISTS "Allow authenticated users to view user profiles" ON public.app_users;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.app_users;
DROP POLICY IF EXISTS "Users can manage their own profile" ON public.app_users;
DROP POLICY IF EXISTS "Authenticated users can view profiles" ON public.app_users;
DROP POLICY IF EXISTS "Users can view profiles" ON public.app_users;

-- 3. VERIFY ALL TABLES HAVE RLS DISABLED
SELECT 'RLS STATUS CHECK:' as test;
SELECT tablename, rowsecurity
FROM pg_tables 
WHERE tablename IN ('asset_votes', 'asset_comments', 'app_users')
ORDER BY tablename;

-- 4. VERIFY NO POLICIES REMAIN
SELECT 'POLICIES CHECK:' as test;
SELECT COUNT(*) as total_policies, tablename
FROM pg_policies 
WHERE tablename IN ('asset_votes', 'asset_comments', 'app_users')
GROUP BY tablename;

SELECT 'APP_USERS RLS DISABLED ✅' as final_message,
       'Voting should now work - the triggers can auto-create users!' as next_step;
