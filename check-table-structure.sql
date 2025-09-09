-- Check Table Structure
-- Run this in Supabase SQL Editor to see the actual table columns

-- Check slot_assets table structure
SELECT 'slot_assets table columns:' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'slot_assets' 
    AND table_schema = 'public'
ORDER BY ordinal_position;

-- Check categories table structure
SELECT 'categories table columns:' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'categories' 
    AND table_schema = 'public'
ORDER BY ordinal_position;

-- Check category_slots table structure
SELECT 'category_slots table columns:' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'category_slots' 
    AND table_schema = 'public'
ORDER BY ordinal_position;

-- Check what data currently exists
SELECT 'Current data counts:' as info;
SELECT 'categories' as table_name, COUNT(*) as count FROM categories
UNION ALL
SELECT 'slot_assets', COUNT(*) FROM slot_assets
UNION ALL  
SELECT 'category_slots', COUNT(*) FROM category_slots;
