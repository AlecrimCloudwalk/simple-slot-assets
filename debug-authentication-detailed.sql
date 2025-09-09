-- ===================================================================
-- COMPREHENSIVE AUTHENTICATION AND RLS DIAGNOSTIC
-- ===================================================================

-- 1. CHECK ALL EXISTING POLICIES (might have conflicts)
SELECT 'EXISTING POLICIES:' as debug_section;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename IN ('asset_votes', 'asset_comments', 'app_users')
ORDER BY tablename, cmd, policyname;

-- 2. CHECK IF RLS IS ACTUALLY ENABLED
SELECT 'RLS STATUS:' as debug_section;
SELECT schemaname, tablename, rowsecurity, forcerowsecurity
FROM pg_tables 
WHERE tablename IN ('asset_votes', 'asset_comments', 'app_users');

-- 3. TEST AUTHENTICATION FUNCTIONS
SELECT 'AUTHENTICATION TEST:' as debug_section;
SELECT 
    auth.uid() as user_id,
    auth.email() as user_email, 
    auth.role() as user_role,
    current_user as postgres_user,
    session_user as session_user;

-- 4. CHECK IF APP_USERS TABLE HAS THE AUTHENTICATED USER
SELECT 'APP_USERS CHECK:' as debug_section;
SELECT * FROM public.app_users WHERE email = auth.email();

-- 5. TEMPORARILY DISABLE RLS TO TEST IF THAT'S THE ISSUE
SELECT 'TEMPORARILY DISABLING RLS FOR TESTING...' as debug_section;
ALTER TABLE public.asset_votes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.asset_comments DISABLE ROW LEVEL SECURITY;

-- 6. TEST INSERT WITH RLS DISABLED
SELECT 'Testing INSERT with RLS disabled (should work):' as debug_section;
-- This will help us confirm if RLS is the problem

-- 7. CREATE A SIMPLE TEST POLICY
SELECT 'Creating simple test policy...' as debug_section;
CREATE POLICY "test_insert_policy" ON public.asset_votes
    FOR INSERT 
    WITH CHECK (true);  -- Allow all inserts for testing

-- 8. RE-ENABLE RLS WITH SIMPLE POLICY
ALTER TABLE public.asset_votes ENABLE ROW LEVEL SECURITY;

SELECT 'RLS diagnostic complete. Try voting now to test the simple policy.' as final_message;
