-- Setup Supabase Storage Bucket for Asset Uploads
-- Run this in Supabase SQL Editor if uploads are failing

-- =============================================
-- CREATE STORAGE BUCKET
-- =============================================

-- Create the slot-assets bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'slot-assets', 
    'slot-assets', 
    true,  -- Public bucket for easy access
    52428800,  -- 50MB limit
    ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'video/mp4', 'video/webm', 'video/quicktime']
)
ON CONFLICT (id) DO UPDATE SET
    public = true,
    file_size_limit = 52428800,
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'video/mp4', 'video/webm', 'video/quicktime'];

-- =============================================
-- STORAGE POLICIES FOR CLOUDWALK USERS
-- =============================================

-- Allow CloudWalk users to upload files
CREATE POLICY "CloudWalk users can upload assets"
ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'slot-assets' AND
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

-- Allow CloudWalk users to view files
CREATE POLICY "CloudWalk users can view assets"
ON storage.objects
FOR SELECT TO authenticated
USING (
  bucket_id = 'slot-assets' AND
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

-- Allow public access to files (since bucket is public)
CREATE POLICY "Public can view slot assets"
ON storage.objects
FOR SELECT
USING (bucket_id = 'slot-assets');

-- Allow CloudWalk users to update files
CREATE POLICY "CloudWalk users can update assets"
ON storage.objects
FOR UPDATE TO authenticated
USING (
  bucket_id = 'slot-assets' AND
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

-- Allow CloudWalk users to delete files  
CREATE POLICY "CloudWalk users can delete assets"
ON storage.objects
FOR DELETE TO authenticated
USING (
  bucket_id = 'slot-assets' AND
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

-- =============================================
-- VERIFY SETUP
-- =============================================

-- Check bucket was created
SELECT 
    id,
    name, 
    public,
    file_size_limit / (1024*1024) as size_limit_mb,
    allowed_mime_types
FROM storage.buckets 
WHERE name = 'slot-assets';

-- Check storage policies
SELECT 
    policyname,
    cmd,
    CASE 
        WHEN qual LIKE '%(SELECT auth.email())%' THEN '✅ OPTIMIZED'
        WHEN qual LIKE '%auth.email()%' THEN '❌ NEEDS OPTIMIZATION'
        ELSE '⚠️ OTHER'
    END as performance_status
FROM pg_policies 
WHERE schemaname = 'storage' 
  AND tablename = 'objects';

-- =============================================
-- SUCCESS MESSAGE
-- =============================================

SELECT 
    '🎉 Storage bucket setup complete!' as message,
    'CloudWalk users can now upload images and videos up to 50MB' as details;
