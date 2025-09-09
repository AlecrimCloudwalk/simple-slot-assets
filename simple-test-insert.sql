-- Simple Test Insert (run in Supabase SQL Editor)
-- This will add just one category to test if the basic setup works

-- Check current user first
SELECT 'Testing with user:' as info, auth.uid() as user_id, auth.email() as email;

-- Try inserting one test category
INSERT INTO public.categories (name, display_name, created_by, color, bg_class, sort_order, is_active) 
VALUES ('test', 'Test Category', auth.uid(), '#4F46E5', 'bg-indigo-500', 1, true);

-- Verify it worked
SELECT * FROM public.categories WHERE name = 'test';

-- If successful, you can delete it and run the full script
-- DELETE FROM public.categories WHERE name = 'test';
