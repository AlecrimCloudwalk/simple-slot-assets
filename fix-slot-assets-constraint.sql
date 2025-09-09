-- Fix slot_assets table constraint for upserts
-- Run this in Supabase SQL Editor

-- Check current table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'slot_assets' 
AND table_schema = 'public';

-- Check existing constraints
SELECT constraint_name, constraint_type 
FROM information_schema.table_constraints 
WHERE table_name = 'slot_assets' 
AND table_schema = 'public';

-- Add unique constraint on slot_name if it doesn't exist
ALTER TABLE public.slot_assets 
ADD CONSTRAINT slot_assets_slot_name_unique 
UNIQUE (slot_name);

-- Verify the constraint was created
SELECT constraint_name, constraint_type 
FROM information_schema.table_constraints 
WHERE table_name = 'slot_assets' 
AND table_schema = 'public';

-- Now ON CONFLICT slot_name will work in your app!
