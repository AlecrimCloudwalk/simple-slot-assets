-- Setup storage bucket and policies for slot-assets
-- Run this in Supabase SQL Editor if having storage access issues

-- First, check if the bucket exists
SELECT name, id, public 
FROM storage.buckets 
WHERE name = 'slot-assets';

-- If the bucket doesn't exist, you need to create it manually in Supabase dashboard:
-- 1. Go to Storage in Supabase dashboard
-- 2. Click "New Bucket" 
-- 3. Name: slot-assets
-- 4. Make it public: true (so URLs work)

-- Check existing RLS policies on storage.objects
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename = 'objects' 
AND schemaname = 'storage';

-- Drop existing policies if they exist (be careful!)
-- DROP POLICY IF EXISTS "CloudWalk users can upload slot assets" ON storage.objects;
-- DROP POLICY IF EXISTS "CloudWalk users can view slot assets" ON storage.objects;
-- DROP POLICY IF EXISTS "CloudWalk users can delete slot assets" ON storage.objects;
-- DROP POLICY IF EXISTS "Anyone can view slot assets" ON storage.objects;

-- Create RLS policies for slot-assets bucket
-- Policy 1: Allow CloudWalk users to insert/upload
CREATE POLICY "CloudWalk users can upload slot assets" ON storage.objects
FOR INSERT 
TO authenticated 
WITH CHECK (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

-- Policy 2: Allow CloudWalk users to select/view  
CREATE POLICY "CloudWalk users can view slot assets" ON storage.objects
FOR SELECT 
TO authenticated 
USING (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

-- Policy 3: Allow CloudWalk users to delete
CREATE POLICY "CloudWalk users can delete slot assets" ON storage.objects
FOR DELETE 
TO authenticated 
USING (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

-- Policy 4: Allow anonymous users to view (for public URLs to work)
CREATE POLICY "Anyone can view slot assets" ON storage.objects
FOR SELECT 
TO anon 
USING (bucket_id = 'slot-assets');

-- Enable RLS on storage.objects if not already enabled
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Check if policies were created successfully
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename = 'objects' 
AND schemaname = 'storage'
AND policyname LIKE '%slot%';
