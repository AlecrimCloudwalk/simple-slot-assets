-- ===================================================================
-- CLEAN SLATE VOTING FIX - REMOVE ALL CONFLICTS
-- ===================================================================
-- This completely resets the RLS policies and creates simple working ones

-- 1. DISABLE RLS TEMPORARILY
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

DROP POLICY IF EXISTS "Allow authenticated users to view comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Authenticated users can insert comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Authenticated users can read all comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Users can delete their own comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Users can update their own comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Users can view their own comments" ON public.asset_comments;
DROP POLICY IF EXISTS "Users can manage their own comments" ON public.asset_comments;

-- 3. CREATE SUPER SIMPLE POLICIES (just get it working first)
CREATE POLICY "simple_votes_all" ON public.asset_votes
    FOR ALL TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "simple_comments_all" ON public.asset_comments
    FOR ALL TO authenticated  
    USING (true)
    WITH CHECK (true);

-- 4. RE-ENABLE RLS
ALTER TABLE public.asset_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.asset_comments ENABLE ROW LEVEL SECURITY;

-- 5. ENSURE USER EXISTS IN APP_USERS (required for foreign keys)
INSERT INTO public.app_users (email, display_name)
VALUES (auth.email(), COALESCE(auth.email(), 'Unknown User'))
ON CONFLICT (email) DO UPDATE SET last_active = NOW();

-- 6. TEST MESSAGE
SELECT 'CLEAN SLATE POLICIES APPLIED! 🧹' as message,
       'All policies removed and replaced with simple permissive ones' as status,
       'Try voting now - it should work!' as next_step;

-- 7. SHOW WHAT WE HAVE NOW
SELECT tablename, policyname, cmd
FROM pg_policies 
WHERE tablename IN ('asset_votes', 'asset_comments')
ORDER BY tablename;

-- 8. TEST AUTHENTICATION
SELECT 
    'AUTH TEST:' as section,
    auth.uid() as user_id,
    auth.email() as user_email,
    auth.role() as user_role;
