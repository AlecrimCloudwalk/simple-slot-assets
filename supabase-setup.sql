-- CloudWalk Asset Manager Database Setup
-- Run this in your Supabase SQL Editor

-- Enable Row Level Security on existing tables
ALTER TABLE IF EXISTS slot_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS category_slots ENABLE ROW LEVEL SECURITY;

-- Create categories table for dynamic category management
CREATE TABLE IF NOT EXISTS categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    description TEXT,
    color VARCHAR(7) DEFAULT '#667eea', -- Hex color code
    bg_class VARCHAR(50),
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create category_slots table for dynamic slot management within categories
CREATE TABLE IF NOT EXISTS category_slots (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT REFERENCES categories(id) ON DELETE CASCADE,
    slot_name VARCHAR(100) NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    description TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(category_id, slot_name)
);

-- Update slot_assets table to support dynamic categories and slots
CREATE TABLE IF NOT EXISTS slot_assets (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT REFERENCES categories(id) ON DELETE CASCADE,
    slot_id BIGINT REFERENCES category_slots(id) ON DELETE CASCADE,
    slot_name VARCHAR(100) NOT NULL, -- Keep for backward compatibility
    filename VARCHAR(255) NOT NULL,
    public_url TEXT NOT NULL,
    storage_path VARCHAR(255) NOT NULL,
    uploaded_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(category_id, slot_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name);
CREATE INDEX IF NOT EXISTS idx_categories_active ON categories(is_active);
CREATE INDEX IF NOT EXISTS idx_category_slots_category ON category_slots(category_id);
CREATE INDEX IF NOT EXISTS idx_category_slots_active ON category_slots(is_active);
CREATE INDEX IF NOT EXISTS idx_slot_assets_category ON slot_assets(category_id);
CREATE INDEX IF NOT EXISTS idx_slot_assets_slot ON slot_assets(slot_id);

-- Create storage bucket for slot assets
INSERT INTO storage.buckets (id, name, public)
VALUES ('slot-assets', 'slot-assets', true)
ON CONFLICT (id) DO NOTHING;

-- RLS Policies for categories table
CREATE POLICY "CloudWalk users can view all categories" ON categories
    FOR SELECT
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can insert categories" ON categories
    FOR INSERT
    TO authenticated
    WITH CHECK (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can update categories" ON categories
    FOR UPDATE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    )
    WITH CHECK (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can delete categories" ON categories
    FOR DELETE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- RLS Policies for category_slots table
CREATE POLICY "CloudWalk users can view all category slots" ON category_slots
    FOR SELECT
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can insert category slots" ON category_slots
    FOR INSERT
    TO authenticated
    WITH CHECK (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can update category slots" ON category_slots
    FOR UPDATE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    )
    WITH CHECK (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can delete category slots" ON category_slots
    FOR DELETE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

-- RLS Policies for slot_assets table
CREATE POLICY "CloudWalk users can view all slot assets" ON slot_assets
    FOR SELECT
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can insert slot assets" ON slot_assets
    FOR INSERT
    TO authenticated
    WITH CHECK (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can update slot assets" ON slot_assets
    FOR UPDATE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    )
    WITH CHECK (
        auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
    );

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

-- Triggers to automatically update updated_at for all tables
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at
    BEFORE UPDATE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_category_slots_updated_at ON category_slots;
CREATE TRIGGER update_category_slots_updated_at
    BEFORE UPDATE ON category_slots
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_slot_assets_updated_at ON slot_assets;
CREATE TRIGGER update_slot_assets_updated_at
    BEFORE UPDATE ON slot_assets
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Insert default categories for backward compatibility
INSERT INTO categories (name, display_name, description, color, bg_class, sort_order, created_by) VALUES
('ai_images', 'AI Images', 'AI-generated image assets', '#667eea', '', 1, 'system'),
('3d_images', '3D Images', '3D rendered image assets', '#28a745', 'mcc-mercadinho', 2, 'system'),
('real_footage', 'Real Footage', 'Real photography and video assets', '#ffc107', 'mcc-roupa', 3, 'system'),
('mercadinho', 'Mercadinho', 'Grocery store/market assets', '#28a745', 'mcc-mercadinho', 4, 'system'),
('loja_de_roupa', 'Loja de Roupa', 'Clothing store assets', '#ffc107', 'mcc-roupa', 5, 'system'),
('sala_beleza_barbearia', 'Sala Beleza/Barbearia', 'Beauty salon/barbershop assets', '#dc3545', 'mcc-beleza', 6, 'system')
ON CONFLICT (name) DO NOTHING;

-- Insert default slots for each category (the 13 original slots)
INSERT INTO category_slots (category_id, slot_name, display_name, sort_order, created_by)
SELECT 
    c.id,
    s.slot_name,
    REPLACE(INITCAP(REPLACE(s.slot_name, '_', ' ')), '_', ' ') as display_name,
    s.sort_order,
    'system'
FROM categories c
CROSS JOIN (
    SELECT 'checkout' as slot_name, 1 as sort_order UNION ALL
    SELECT 'create_bill', 2 UNION ALL
    SELECT 'dirf', 3 UNION ALL
    SELECT 'infinite_card', 4 UNION ALL
    SELECT 'infinite_cash_can_request_limit', 5 UNION ALL
    SELECT 'infinite_cash', 6 UNION ALL
    SELECT 'instant_settlement', 7 UNION ALL
    SELECT 'pay_bill', 8 UNION ALL
    SELECT 'piselli', 9 UNION ALL
    SELECT 'pix_credit', 10 UNION ALL
    SELECT 'referral', 11 UNION ALL
    SELECT 'supercobra', 12 UNION ALL
    SELECT 'tap', 13
) s
WHERE c.created_by = 'system'
ON CONFLICT (category_id, slot_name) DO NOTHING;

-- Create a view for easier querying
CREATE OR REPLACE VIEW v_category_structure AS
SELECT 
    c.id as category_id,
    c.name as category_name,
    c.display_name as category_display_name,
    c.color as category_color,
    c.bg_class as category_bg_class,
    c.sort_order as category_sort_order,
    cs.id as slot_id,
    cs.slot_name,
    cs.display_name as slot_display_name,
    cs.sort_order as slot_sort_order,
    sa.filename,
    sa.public_url,
    sa.storage_path,
    sa.uploaded_by as asset_uploaded_by,
    sa.created_at as asset_created_at,
    sa.updated_at as asset_updated_at
FROM categories c
LEFT JOIN category_slots cs ON c.id = cs.category_id AND cs.is_active = true
LEFT JOIN slot_assets sa ON cs.id = sa.slot_id
WHERE c.is_active = true
ORDER BY c.sort_order, cs.sort_order;

-- The system is now ready for dynamic category and slot management
-- Existing assets will need to be migrated to the new structure
