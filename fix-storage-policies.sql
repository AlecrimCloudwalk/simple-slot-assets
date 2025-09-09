-- Fix storage policies for slot-assets bucket
-- IMPORTANT: Run this in Supabase SQL Editor manually

-- First, check what storage policies currently exist
SELECT policyname, cmd, roles, qual, with_check 
FROM pg_policies 
WHERE schemaname = 'storage' 
AND tablename = 'objects';

-- Drop any existing conflicting policies for slot-assets
-- (Uncomment these lines after checking what exists)
-- DROP POLICY IF EXISTS "Users can insert objects" ON storage.objects;
-- DROP POLICY IF EXISTS "Users can view objects" ON storage.objects;
-- DROP POLICY IF EXISTS "CloudWalk users can upload slot assets" ON storage.objects;
-- DROP POLICY IF EXISTS "CloudWalk users can view slot assets" ON storage.objects;
-- DROP POLICY IF EXISTS "CloudWalk users can delete slot assets" ON storage.objects;
-- DROP POLICY IF EXISTS "Anyone can view slot assets" ON storage.objects;

-- Create specific policies for slot-assets bucket

-- Policy 1: Allow authenticated CloudWalk users to upload to slot-assets
CREATE POLICY "CloudWalk users can upload to slot-assets" ON storage.objects
FOR INSERT TO authenticated 
WITH CHECK (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

-- Policy 2: Allow authenticated CloudWalk users to view slot-assets  
CREATE POLICY "CloudWalk users can view slot-assets" ON storage.objects
FOR SELECT TO authenticated
USING (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

-- Policy 3: Allow authenticated CloudWalk users to update slot-assets
CREATE POLICY "CloudWalk users can update slot-assets" ON storage.objects
FOR UPDATE TO authenticated
USING (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
)
WITH CHECK (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

-- Policy 4: Allow authenticated CloudWalk users to delete slot-assets
CREATE POLICY "CloudWalk users can delete slot-assets" ON storage.objects
FOR DELETE TO authenticated
USING (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

-- Policy 5: Allow anonymous users to view slot-assets (for public URLs)
CREATE POLICY "Public can view slot-assets" ON storage.objects
FOR SELECT TO anon
USING (bucket_id = 'slot-assets');

-- Ensure RLS is enabled on storage.objects
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Check that the bucket exists (should show 1 row)
SELECT name, id, public 
FROM storage.buckets 
WHERE name = 'slot-assets';

-- If the above query returns no results, create the bucket:
-- INSERT INTO storage.buckets (id, name, public) 
-- VALUES ('slot-assets', 'slot-assets', true);

-- Verify policies were created successfully
SELECT policyname, cmd, roles, qual, with_check 
FROM pg_policies 
WHERE schemaname = 'storage' 
AND tablename = 'objects'
AND policyname LIKE '%slot-assets%';
