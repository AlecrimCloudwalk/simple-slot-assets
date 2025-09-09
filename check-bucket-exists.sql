-- This you CAN run in SQL Editor to check if bucket exists
-- Go to: Supabase Dashboard → SQL Editor → New Query

-- Check if slot-assets bucket exists
SELECT 
    name, 
    id, 
    public,
    created_at 
FROM storage.buckets 
WHERE name = 'slot-assets';

-- If no results, the bucket doesn't exist
-- Go to Storage → "New Bucket" → Name: "slot-assets" → Public: true
