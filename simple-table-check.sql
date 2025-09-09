-- Simple Table Structure Check
-- Run this to see what columns exist in slot_assets

-- Method 1: Try to select from slot_assets to see column names
SELECT 'Checking slot_assets columns...' as info;

-- This will show us what columns exist (even if no data)
-- Run this and the error message will tell us the actual column names
SELECT * FROM public.slot_assets LIMIT 1;

-- Method 2: Alternative column check
\d public.slot_assets

-- Method 3: If the above don't work, try this
SELECT table_name, column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'slot_assets' 
  AND table_schema = 'public';
