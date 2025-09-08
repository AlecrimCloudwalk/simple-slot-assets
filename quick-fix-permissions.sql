-- Quick Fix: Update RLS Policies to Work Properly
-- This fixes the timeout issue by using more reliable authentication checks

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "CloudWalk users can view all categories" ON categories;
DROP POLICY IF EXISTS "CloudWalk users can view all category slots" ON category_slots;
DROP POLICY IF EXISTS "CloudWalk users can view all slot assets" ON slot_assets;

DROP POLICY IF EXISTS "CloudWalk users can insert categories" ON categories;
DROP POLICY IF EXISTS "CloudWalk users can insert category slots" ON category_slots;
DROP POLICY IF EXISTS "CloudWalk users can insert slot assets" ON slot_assets;

DROP POLICY IF EXISTS "CloudWalk users can update categories" ON categories;
DROP POLICY IF EXISTS "CloudWalk users can update category slots" ON category_slots;
DROP POLICY IF EXISTS "CloudWalk users can update slot assets" ON slot_assets;

DROP POLICY IF EXISTS "CloudWalk users can delete categories" ON categories;
DROP POLICY IF EXISTS "CloudWalk users can delete category slots" ON category_slots;
DROP POLICY IF EXISTS "CloudWalk users can delete slot assets" ON slot_assets;

-- Create new, more reliable policies

-- Categories policies - using auth.email() function which is more reliable
CREATE POLICY "CloudWalk users can view all categories" ON categories
    FOR SELECT TO authenticated
    USING (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can manage categories" ON categories
    FOR ALL TO authenticated
    USING (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    )
    WITH CHECK (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Category slots policies
CREATE POLICY "CloudWalk users can view all category slots" ON category_slots
    FOR SELECT TO authenticated
    USING (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can manage category slots" ON category_slots
    FOR ALL TO authenticated
    USING (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    )
    WITH CHECK (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Slot assets policies
CREATE POLICY "CloudWalk users can view all slot assets" ON slot_assets
    FOR SELECT TO authenticated
    USING (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    );

CREATE POLICY "CloudWalk users can manage slot assets" ON slot_assets
    FOR ALL TO authenticated
    USING (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    )
    WITH CHECK (
        auth.email() LIKE '%@cloudwalk.io' 
        OR auth.jwt() ->> 'email' LIKE '%@cloudwalk.io'
        OR auth.jwt() -> 'user_metadata' ->> 'email' LIKE '%@cloudwalk.io'
    );

-- Test the fix
SELECT 'Permission fix applied! Testing view...' as status;

-- Test if the view works now
SELECT COUNT(*) as total_view_rows FROM v_category_structure;

SELECT 
    category_display_name as category,
    COUNT(slot_id) as slots_count
FROM v_category_structure 
GROUP BY category_id, category_display_name
ORDER BY category_id;

SELECT 'If you see categories above, the fix worked!' as status;
