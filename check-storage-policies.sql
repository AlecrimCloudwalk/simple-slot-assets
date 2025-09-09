-- Check current storage policies
SELECT 
    schemaname,
    tablename, 
    policyname,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE schemaname = 'storage' 
AND tablename = 'objects'
ORDER BY policyname;
