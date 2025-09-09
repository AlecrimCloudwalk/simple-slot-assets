-- PRODUCTION-READY VOTING SYSTEM FOR CLOUDWALK SLOT ASSETS
-- This approach scales infinitely and provides excellent query performance

-- ===================================================================
-- 1. USER TRACKING TABLE (for data integrity)
-- ===================================================================
CREATE TABLE IF NOT EXISTS public.app_users (
    email TEXT PRIMARY KEY,
    display_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    last_active TIMESTAMP DEFAULT NOW()
);

-- Create trigger to auto-insert users when they vote/comment
CREATE OR REPLACE FUNCTION ensure_user_exists()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.app_users (email, display_name) 
    VALUES (NEW.user_email, split_part(NEW.user_email, '@', 1))
    ON CONFLICT (email) DO UPDATE SET last_active = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ===================================================================
-- 2. VOTES TABLE (clean, scalable, indexed)
-- ===================================================================
CREATE TABLE IF NOT EXISTS public.asset_votes (
    id SERIAL PRIMARY KEY,
    slot_name TEXT NOT NULL,
    user_email TEXT NOT NULL,
    vote_type VARCHAR(10) NOT NULL CHECK (vote_type IN ('upvote', 'downvote')),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    -- Ensure one vote per user per asset
    UNIQUE(slot_name, user_email),
    
    -- Foreign key to slot_assets
    FOREIGN KEY (slot_name) REFERENCES public.slot_assets(slot_name) ON DELETE CASCADE,
    
    -- Foreign key to users (will be created by trigger)
    FOREIGN KEY (user_email) REFERENCES public.app_users(email) ON DELETE CASCADE
);

-- Create trigger to ensure user exists
CREATE TRIGGER ensure_user_exists_votes
    BEFORE INSERT OR UPDATE ON public.asset_votes
    FOR EACH ROW EXECUTE FUNCTION ensure_user_exists();

-- ===================================================================
-- 3. COMMENTS TABLE (unlimited scaling, proper relationships)
-- ===================================================================
CREATE TABLE IF NOT EXISTS public.asset_comments (
    id SERIAL PRIMARY KEY,
    slot_name TEXT NOT NULL,
    user_email TEXT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    -- Foreign keys for data integrity
    FOREIGN KEY (slot_name) REFERENCES public.slot_assets(slot_name) ON DELETE CASCADE,
    FOREIGN KEY (user_email) REFERENCES public.app_users(email) ON DELETE CASCADE
);

-- Create trigger to ensure user exists
CREATE TRIGGER ensure_user_exists_comments
    BEFORE INSERT OR UPDATE ON public.asset_comments
    FOR EACH ROW EXECUTE FUNCTION ensure_user_exists();

-- ===================================================================
-- 4. HIGH-PERFORMANCE INDEXES
-- ===================================================================

-- Votes table indexes
CREATE INDEX IF NOT EXISTS idx_asset_votes_slot_name ON public.asset_votes(slot_name);
CREATE INDEX IF NOT EXISTS idx_asset_votes_user_email ON public.asset_votes(user_email);
CREATE INDEX IF NOT EXISTS idx_asset_votes_type ON public.asset_votes(vote_type);
CREATE INDEX IF NOT EXISTS idx_asset_votes_created_at ON public.asset_votes(created_at);

-- Comments table indexes  
CREATE INDEX IF NOT EXISTS idx_asset_comments_slot_name ON public.asset_comments(slot_name);
CREATE INDEX IF NOT EXISTS idx_asset_comments_user_email ON public.asset_comments(user_email);
CREATE INDEX IF NOT EXISTS idx_asset_comments_created_at ON public.asset_comments(created_at);

-- ===================================================================
-- 5. CACHED VOTE COUNTS (for UI performance)
-- ===================================================================

-- Add computed columns to slot_assets for cached counts
ALTER TABLE public.slot_assets 
ADD COLUMN IF NOT EXISTS upvotes_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS downvotes_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS comments_count INTEGER DEFAULT 0;

-- Function to update cached vote counts
CREATE OR REPLACE FUNCTION update_vote_counts(target_slot_name TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE public.slot_assets SET
        upvotes_count = (
            SELECT COUNT(*) FROM public.asset_votes 
            WHERE slot_name = target_slot_name AND vote_type = 'upvote'
        ),
        downvotes_count = (
            SELECT COUNT(*) FROM public.asset_votes 
            WHERE slot_name = target_slot_name AND vote_type = 'downvote'
        ),
        comments_count = (
            SELECT COUNT(*) FROM public.asset_comments 
            WHERE slot_name = target_slot_name
        )
    WHERE slot_name = target_slot_name;
END;
$$ LANGUAGE plpgsql;

-- Triggers to automatically update cached counts
CREATE OR REPLACE FUNCTION trigger_update_vote_counts()
RETURNS TRIGGER AS $$
BEGIN
    -- Handle INSERT, UPDATE, DELETE for votes
    IF TG_OP = 'DELETE' THEN
        PERFORM update_vote_counts(OLD.slot_name);
        RETURN OLD;
    ELSE
        PERFORM update_vote_counts(NEW.slot_name);
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_update_comment_counts()
RETURNS TRIGGER AS $$
BEGIN
    -- Handle INSERT, UPDATE, DELETE for comments
    IF TG_OP = 'DELETE' THEN
        PERFORM update_vote_counts(OLD.slot_name);
        RETURN OLD;
    ELSE
        PERFORM update_vote_counts(NEW.slot_name);
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
DROP TRIGGER IF EXISTS update_vote_counts_trigger ON public.asset_votes;
CREATE TRIGGER update_vote_counts_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.asset_votes
    FOR EACH ROW EXECUTE FUNCTION trigger_update_vote_counts();

DROP TRIGGER IF EXISTS update_comment_counts_trigger ON public.asset_comments;
CREATE TRIGGER update_comment_counts_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.asset_comments
    FOR EACH ROW EXECUTE FUNCTION trigger_update_comment_counts();

-- ===================================================================
-- 6. POWERFUL ANALYTICS VIEWS
-- ===================================================================

-- View: Asset feedback summary
CREATE OR REPLACE VIEW asset_feedback_summary AS
SELECT 
    sa.slot_name,
    sa.filename,
    sa.public_url,
    sa.upvotes_count,
    sa.downvotes_count,
    sa.comments_count,
    sa.uploaded_by,
    sa.updated_at,
    -- Calculate feedback score
    (sa.upvotes_count - sa.downvotes_count) as score,
    -- Determine if asset needs attention
    CASE 
        WHEN sa.downvotes_count > sa.upvotes_count THEN true 
        ELSE false 
    END as needs_review,
    -- Get latest comment
    (SELECT comment FROM public.asset_comments 
     WHERE slot_name = sa.slot_name 
     ORDER BY created_at DESC LIMIT 1) as latest_comment
FROM public.slot_assets sa
ORDER BY sa.downvotes_count DESC, sa.upvotes_count DESC;

-- View: User activity summary
CREATE OR REPLACE VIEW user_activity_summary AS
SELECT 
    u.email,
    u.display_name,
    COUNT(v.id) as total_votes,
    COUNT(c.id) as total_comments,
    COUNT(v.id) FILTER (WHERE v.vote_type = 'upvote') as upvotes_given,
    COUNT(v.id) FILTER (WHERE v.vote_type = 'downvote') as downvotes_given,
    u.last_active
FROM public.app_users u
LEFT JOIN public.asset_votes v ON u.email = v.user_email
LEFT JOIN public.asset_comments c ON u.email = c.user_email
GROUP BY u.email, u.display_name, u.last_active
ORDER BY u.last_active DESC;

-- ===================================================================
-- 7. UTILITY FUNCTIONS FOR FRONTEND
-- ===================================================================

-- Get vote summary for dashboard
CREATE OR REPLACE FUNCTION get_system_stats()
RETURNS TABLE(
    total_assets bigint,
    total_votes bigint,
    total_upvotes bigint,
    total_downvotes bigint,
    total_comments bigint,
    assets_needing_review bigint,
    active_users bigint
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*) FROM public.slot_assets)::bigint,
        (SELECT COUNT(*) FROM public.asset_votes)::bigint,
        (SELECT COUNT(*) FROM public.asset_votes WHERE vote_type = 'upvote')::bigint,
        (SELECT COUNT(*) FROM public.asset_votes WHERE vote_type = 'downvote')::bigint,
        (SELECT COUNT(*) FROM public.asset_comments)::bigint,
        (SELECT COUNT(*) FROM public.slot_assets WHERE downvotes_count > upvotes_count)::bigint,
        (SELECT COUNT(*) FROM public.app_users WHERE last_active > NOW() - INTERVAL '7 days')::bigint;
END;
$$ LANGUAGE plpgsql;

-- Get user's vote on specific asset
CREATE OR REPLACE FUNCTION get_user_vote(user_email_param TEXT, slot_name_param TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN (SELECT vote_type FROM public.asset_votes 
            WHERE user_email = user_email_param AND slot_name = slot_name_param);
END;
$$ LANGUAGE plpgsql;

-- ===================================================================
-- 8. INITIALIZE EXISTING DATA
-- ===================================================================

-- Update cached counts for all existing assets
SELECT update_vote_counts(slot_name) FROM public.slot_assets;

-- ===================================================================
-- 9. ROW LEVEL SECURITY (RLS) POLICIES
-- ===================================================================

-- Enable RLS on new tables
ALTER TABLE public.asset_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.asset_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_users ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to read all votes/comments
CREATE POLICY "Allow authenticated users to view votes" ON public.asset_votes
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view comments" ON public.asset_comments
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view user profiles" ON public.app_users
    FOR SELECT USING (auth.role() = 'authenticated');

-- Allow users to manage their own votes
CREATE POLICY "Users can manage their own votes" ON public.asset_votes
    FOR ALL USING (auth.email() = user_email);

-- Allow users to manage their own comments
CREATE POLICY "Users can manage their own comments" ON public.asset_comments
    FOR ALL USING (auth.email() = user_email);

-- Allow users to update their own profile
CREATE POLICY "Users can update their own profile" ON public.app_users
    FOR UPDATE USING (auth.email() = email);

-- ===================================================================
-- 10. SUCCESS MESSAGE
-- ===================================================================

SELECT 'Production-ready voting system installed successfully! 🎉' as message,
       'Tables: app_users, asset_votes, asset_comments' as tables_created,
       'Views: asset_feedback_summary, user_activity_summary' as views_created,
       'Functions: update_vote_counts, get_system_stats, get_user_vote' as functions_created;

-- Show system stats
SELECT * FROM get_system_stats();
