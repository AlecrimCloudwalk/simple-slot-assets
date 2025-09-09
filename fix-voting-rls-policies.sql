-- ===================================================================
-- FIX VOTING SYSTEM RLS POLICIES
-- ===================================================================
-- Problem: Current policies use "FOR ALL" which blocks INSERT operations
-- Solution: Separate INSERT policies (auth only) from SELECT/UPDATE/DELETE policies (ownership check)

-- Drop the problematic policies
DROP POLICY IF EXISTS "Users can manage their own votes" ON public.asset_votes;
DROP POLICY IF EXISTS "Users can manage their own comments" ON public.asset_comments;

-- ===================================================================
-- FIXED ASSET_VOTES POLICIES
-- ===================================================================

-- Allow authenticated users to insert votes (no ownership check needed on INSERT)
CREATE POLICY "Authenticated users can insert votes" ON public.asset_votes
    FOR INSERT TO authenticated
    WITH CHECK (auth.email() IS NOT NULL);

-- Allow users to view, update, delete their own votes
CREATE POLICY "Users can view their own votes" ON public.asset_votes
    FOR SELECT TO authenticated
    USING (auth.email() = user_email);

CREATE POLICY "Users can update their own votes" ON public.asset_votes
    FOR UPDATE TO authenticated
    USING (auth.email() = user_email)
    WITH CHECK (auth.email() = user_email);

CREATE POLICY "Users can delete their own votes" ON public.asset_votes
    FOR DELETE TO authenticated
    USING (auth.email() = user_email);

-- ===================================================================
-- FIXED ASSET_COMMENTS POLICIES  
-- ===================================================================

-- Allow authenticated users to insert comments (no ownership check needed on INSERT)
CREATE POLICY "Authenticated users can insert comments" ON public.asset_comments
    FOR INSERT TO authenticated
    WITH CHECK (auth.email() IS NOT NULL);

-- Allow users to view, update, delete their own comments
CREATE POLICY "Users can view their own comments" ON public.asset_comments
    FOR SELECT TO authenticated
    USING (auth.email() = user_email);

CREATE POLICY "Users can update their own comments" ON public.asset_comments
    FOR UPDATE TO authenticated
    USING (auth.email() = user_email)
    WITH CHECK (auth.email() = user_email);

CREATE POLICY "Users can delete their own comments" ON public.asset_comments
    FOR DELETE TO authenticated
    USING (auth.email() = user_email);

-- ===================================================================
-- ENABLE UNIVERSAL READ ACCESS FOR VOTING DISPLAY
-- ===================================================================

-- Allow authenticated users to read ALL votes (for vote count display)
CREATE POLICY "Authenticated users can read all votes" ON public.asset_votes
    FOR SELECT TO authenticated
    USING (true);

-- Allow authenticated users to read ALL comments (for comment display)  
CREATE POLICY "Authenticated users can read all comments" ON public.asset_comments
    FOR SELECT TO authenticated
    USING (true);

-- ===================================================================
-- TEST THE FIX
-- ===================================================================

SELECT 'RLS policies fixed! 🎉' as message,
       'Voting and commenting should now work for authenticated users' as status;

-- Show current policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('asset_votes', 'asset_comments')
ORDER BY tablename, policyname;
