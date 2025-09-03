-- CloudWalk Asset Manager Database Setup
-- Run this in your Supabase SQL Editor

-- Enable Row Level Security
ALTER TABLE IF EXISTS slot_assets ENABLE ROW LEVEL SECURITY;

-- Create slot_assets table
CREATE TABLE IF NOT EXISTS slot_assets (
    id BIGSERIAL PRIMARY KEY,
    slot_name VARCHAR(100) UNIQUE NOT NULL,
    filename VARCHAR(255) NOT NULL,
    public_url TEXT NOT NULL,
    storage_path VARCHAR(255) NOT NULL,
    uploaded_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create storage bucket for slot assets
INSERT INTO storage.buckets (id, name, public)
VALUES ('slot-assets', 'slot-assets', true)
ON CONFLICT (id) DO NOTHING;

-- RLS Policies for slot_assets table
-- Allow authenticated users from cloudwalk.io domain to read all records
CREATE POLICY "CloudWalk users can view all slot assets" ON slot_assets
    FOR SELECT
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Allow authenticated users from cloudwalk.io domain to insert records
CREATE POLICY "CloudWalk users can insert slot assets" ON slot_assets
    FOR INSERT
    TO authenticated
    WITH CHECK (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Allow authenticated users from cloudwalk.io domain to update records
CREATE POLICY "CloudWalk users can update slot assets" ON slot_assets
    FOR UPDATE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    )
    WITH CHECK (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Allow authenticated users from cloudwalk.io domain to delete records
CREATE POLICY "CloudWalk users can delete slot assets" ON slot_assets
    FOR DELETE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Storage policies for slot-assets bucket
-- Allow authenticated cloudwalk.io users to upload files
CREATE POLICY "CloudWalk users can upload slot assets" ON storage.objects
    FOR INSERT
    TO authenticated
    WITH CHECK (
        bucket_id = 'slot-assets' 
        AND auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Allow authenticated cloudwalk.io users to view files
CREATE POLICY "CloudWalk users can view slot assets" ON storage.objects
    FOR SELECT
    TO authenticated
    USING (
        bucket_id = 'slot-assets' 
        AND auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Allow authenticated cloudwalk.io users to delete files
CREATE POLICY "CloudWalk users can delete slot assets" ON storage.objects
    FOR DELETE
    TO authenticated
    USING (
        bucket_id = 'slot-assets' 
        AND auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Allow public access to view files (for sharing with stakeholders)
CREATE POLICY "Public can view slot assets" ON storage.objects
    FOR SELECT
    TO public
    USING (bucket_id = 'slot-assets');

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
DROP TRIGGER IF EXISTS update_slot_assets_updated_at ON slot_assets;
CREATE TRIGGER update_slot_assets_updated_at
    BEFORE UPDATE ON slot_assets
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- The table is ready for use - slots will be populated when users upload assets
-- No initial records needed since we want to start with empty slots
