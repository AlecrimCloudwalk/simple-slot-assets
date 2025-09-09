-- Fix public access to uploaded images
-- Run this in Supabase SQL Editor

-- Drop existing public policy if it exists
DROP POLICY IF EXISTS "Public can view slot-assets" ON storage.objects;

-- Create new public read policy
CREATE POLICY "Public can view slot-assets" ON storage.objects
FOR SELECT TO anon
USING (bucket_id = 'slot-assets');

-- Verify the policy was created
SELECT policyname, roles, cmd 
FROM pg_policies 
WHERE schemaname = 'storage' 
AND tablename = 'objects'
AND policyname = 'Public can view slot-assets';
