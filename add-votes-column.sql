-- Add votes column to slot_assets table for upvote/downvote functionality
-- This stores JSON data containing upvotes, downvotes, comments, and user vote tracking

-- Add votes column as JSONB for better performance and querying
ALTER TABLE public.slot_assets 
ADD COLUMN votes JSONB DEFAULT '{"upvotes": 0, "downvotes": 0, "comments": 0, "user_votes": {}, "comments_data": []}';

-- Add index on votes column for better query performance
CREATE INDEX idx_slot_assets_votes ON public.slot_assets USING GIN (votes);

-- Add index specifically for downvotes filtering (for UI styling)
CREATE INDEX idx_slot_assets_downvotes ON public.slot_assets USING GIN ((votes -> 'downvotes'));

-- Update existing rows to have default vote structure
UPDATE public.slot_assets 
SET votes = '{"upvotes": 0, "downvotes": 0, "comments": 0, "user_votes": {}, "comments_data": []}'::jsonb
WHERE votes IS NULL;

-- Optional: Create view for slots with downvotes (for reporting)
CREATE OR REPLACE VIEW slot_assets_with_feedback AS
SELECT 
    slot_name,
    filename,
    public_url,
    (votes->>'upvotes')::int as upvotes,
    (votes->>'downvotes')::int as downvotes, 
    (votes->>'comments')::int as comments,
    votes->'comments_data' as comments_data,
    uploaded_by,
    updated_at
FROM public.slot_assets
WHERE votes IS NOT NULL;

-- Optional: Create function to get vote summary
CREATE OR REPLACE FUNCTION get_vote_summary()
RETURNS TABLE(
    total_assets bigint,
    total_upvotes bigint,
    total_downvotes bigint,
    assets_with_downvotes bigint
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_assets,
        SUM((votes->>'upvotes')::int) as total_upvotes,
        SUM((votes->>'downvotes')::int) as total_downvotes,
        COUNT(*) FILTER (WHERE (votes->>'downvotes')::int > 0) as assets_with_downvotes
    FROM public.slot_assets
    WHERE votes IS NOT NULL;
END;
$$ LANGUAGE plpgsql;

-- Test the setup
SELECT 'Votes column added successfully!' as message;

-- Show sample data
SELECT slot_name, votes FROM public.slot_assets LIMIT 3;
