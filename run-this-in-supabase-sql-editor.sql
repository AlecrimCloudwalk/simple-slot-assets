-- COPY AND PASTE THIS INTO SUPABASE SQL EDITOR
-- Go to: Supabase Dashboard → SQL Editor → New Query → Paste this

-- Step 1: Check if slot-assets bucket exists
SELECT name, id, public FROM storage.buckets WHERE name = 'slot-assets';

-- Step 2: If no results above, create the bucket (uncomment next line)
-- INSERT INTO storage.buckets (id, name, public) VALUES ('slot-assets', 'slot-assets', true);

-- Step 3: Check current storage policies
SELECT policyname, cmd, roles FROM pg_policies 
WHERE schemaname = 'storage' AND tablename = 'objects';

-- Step 4: Create storage policies for CloudWalk users

-- Drop existing conflicting policies if they exist
DROP POLICY IF EXISTS "CloudWalk users can upload to slot-assets" ON storage.objects;
DROP POLICY IF EXISTS "CloudWalk users can view slot-assets" ON storage.objects;
DROP POLICY IF EXISTS "CloudWalk users can update slot-assets" ON storage.objects;
DROP POLICY IF EXISTS "CloudWalk users can delete slot-assets" ON storage.objects;
DROP POLICY IF EXISTS "Public can view slot-assets" ON storage.objects;

-- Create new policies
CREATE POLICY "CloudWalk users can upload to slot-assets" ON storage.objects
FOR INSERT TO authenticated 
WITH CHECK (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can view slot-assets" ON storage.objects
FOR SELECT TO authenticated
USING (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can delete slot-assets" ON storage.objects
FOR DELETE TO authenticated
USING (
    bucket_id = 'slot-assets' 
    AND auth.email() LIKE '%@cloudwalk.io'
);

CREATE POLICY "Public can view slot-assets" ON storage.objects
FOR SELECT TO anon
USING (bucket_id = 'slot-assets');

-- Step 5: Enable RLS
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Step 6: Verify policies were created
SELECT policyname, cmd, roles FROM pg_policies 
WHERE schemaname = 'storage' AND tablename = 'objects'
AND policyname LIKE '%slot-assets%';

-- You should see 4 policies created for slot-assets
