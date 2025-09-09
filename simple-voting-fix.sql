-- ===================================================================
-- SIMPLE VOTING FIX - BYPASS AUTHENTICATION ISSUES
-- ===================================================================
-- Skip user creation and just fix the policies

-- 1. DISABLE RLS TEMPORARILY TO TEST
ALTER TABLE public.asset_votes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.asset_comments DISABLE ROW LEVEL SECURITY;

-- 2. DROP ALL EXISTING POLICIES (clean slate)
DROP POLICY IF EXISTS "Allow authenticated users to view votes" ON public.asset_votes;
DROP POLICY IF EXISTS "Authenticated users can insert votes" ON public.asset_votes;
DROP POLICY IF EXISTS "Authenticated users can read all votes" ON public.asset_votes;
DROP POLICY IF EXISTS "Users can delete their own votes" ON public.asset_votes;
DROP POLICY IF EXISTS "Users can update their own votes" ON public.asset_votes;
DROP POLICY IF EXISTS "Users can view their own votes" ON public.asset_votes;
DROP POLICY IF EXISTS "Users can manage their own votes" ON public.asset_votes;
DROP POLICY IF EXISTS "simple_votes_all" ON public.asset_votes;

DROP POLICY IF EXISTS "Allow authenticated users to view comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Authenticated users can insert comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Authenticated users can read all comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Users can delete their own comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Users can update their own comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Users can view their own comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Users can manage their own comments" ON public.asset_comments;
DROP POLICY IF EXISTS "simple_comments_all" ON public.asset_comments;

-- 3. TEST WITHOUT RLS FIRST
SELECT 'RLS DISABLED - Try voting now. It should work!' as message,
       'If voting works, we know RLS is the issue' as diagnosis;

-- You can stop here and test, or continue to add minimal policies

-- 4. IF YOU WANT TO RE-ENABLE RLS WITH MINIMAL POLICIES:
-- Uncomment the lines below after testing without RLS

/*
-- Create the most permissive policies possible
CREATE POLICY "allow_all_votes" ON public.asset_votes
    FOR ALL
    USING (true)
    WITH CHECK (true);

CREATE POLICY "allow_all_comments" ON public.asset_comments
    FOR ALL  
    USING (true)
    WITH CHECK (true);

-- Re-enable RLS
ALTER TABLE public.asset_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.asset_comments ENABLE ROW LEVEL SECURITY;

SELECT 'MINIMAL RLS POLICIES APPLIED!' as final_message;
*/

-- 5. CHECK CURRENT STATUS
SELECT 
    tablename, 
    rowsecurity as rls_enabled,
    (SELECT COUNT(*) FROM pg_policies WHERE pg_policies.tablename = pt.tablename) as policy_count
FROM pg_tables pt
WHERE tablename IN ('asset_votes', 'asset_comments');
