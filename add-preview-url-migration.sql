-- Migration: Add preview_url column for video thumbnails
-- Run this in your Supabase SQL Editor

-- Add preview_url column to slot_assets table
ALTER TABLE slot_assets 
ADD COLUMN IF NOT EXISTS preview_url TEXT;

-- Update existing records to use public_url as preview_url if not set
UPDATE slot_assets 
SET preview_url = public_url 
WHERE preview_url IS NULL;

-- Comment: 
-- The preview_url field will store:
-- - For images: same as public_url (the image itself)
-- - For videos: URL to the generated thumbnail image
