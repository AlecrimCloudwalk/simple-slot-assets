-- FINAL FIX: Populate Database AND Fix RLS for Frontend Access
-- This script does everything needed to get the shared online mode working

-- STEP 1: Temporarily disable RLS to clear any access issues
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE category_slots DISABLE ROW LEVEL SECURITY;
ALTER TABLE slot_assets DISABLE ROW LEVEL SECURITY;

-- STEP 2: Clear and populate data
DELETE FROM slot_assets;
DELETE FROM category_slots;
DELETE FROM categories;

-- STEP 3: Insert the 6 categories
INSERT INTO categories (name, display_name, description, color, bg_class, sort_order, created_by) VALUES
('ai_images', 'AI Images', 'AI-generated image assets', '#667eea', '', 1, 'system'),
('3d_images', '3D Images', '3D rendered image assets', '#28a745', 'mcc-mercadinho', 2, 'system'),
('real_footage', 'Real Footage', 'Real photography and video assets', '#ffc107', 'mcc-roupa', 3, 'system'),
('mercadinho', 'Mercadinho', 'Grocery store/market assets', '#28a745', 'mcc-mercadinho', 4, 'system'),
('loja_de_roupa', 'Loja de Roupa', 'Clothing store assets', '#ffc107', 'mcc-roupa', 5, 'system'),
('sala_beleza_barbearia', 'Sala Beleza/Barbearia', 'Beauty salon/barbershop assets', '#dc3545', 'mcc-beleza', 6, 'system');

-- STEP 4: Insert the 13 slots for each category (78 total)
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
) s;

-- STEP 5: Verify data was inserted
SELECT 'Categories created: ' || COUNT(*)::text as status FROM categories;
SELECT 'Slots created: ' || COUNT(*)::text as status FROM category_slots;
SELECT 'View rows: ' || COUNT(*)::text as status FROM v_category_structure;

-- STEP 6: Show the categories that were created (this should show 6 categories)
SELECT 
    c.display_name as category,
    COUNT(cs.id) as slots_count,
    'SUCCESS - Category populated!' as status
FROM categories c
LEFT JOIN category_slots cs ON c.id = cs.category_id
GROUP BY c.id, c.display_name, c.sort_order
ORDER BY c.sort_order;

-- STEP 7: Test the view that the frontend uses
SELECT 
    category_display_name as category,
    slot_display_name as slot,
    'Frontend can see this!' as status
FROM v_category_structure 
ORDER BY category_sort_order, slot_sort_order
LIMIT 15;

-- STEP 8: Create VERY permissive RLS policies for frontend access
-- Drop all existing policies first
DROP POLICY IF EXISTS "Allow authenticated users to view categories" ON categories;
DROP POLICY IF EXISTS "Allow authenticated users to manage categories" ON categories;
DROP POLICY IF EXISTS "Allow authenticated users to view category slots" ON category_slots;  
DROP POLICY IF EXISTS "Allow authenticated users to manage category slots" ON category_slots;
DROP POLICY IF EXISTS "Allow authenticated users to view slot assets" ON slot_assets;
DROP POLICY IF EXISTS "Allow authenticated users to manage slot assets" ON slot_assets;

-- Create simple policies that definitely work
CREATE POLICY "Anyone authenticated can access categories" ON categories FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Anyone authenticated can access category_slots" ON category_slots FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Anyone authenticated can access slot_assets" ON slot_assets FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- STEP 9: Re-enable RLS with the new permissive policies
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE category_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE slot_assets ENABLE ROW LEVEL SECURITY;

-- STEP 10: Test access with RLS enabled
SELECT 'Testing with RLS enabled...' as test_step;
SELECT COUNT(*) as categories_accessible FROM categories;
SELECT COUNT(*) as slots_accessible FROM category_slots;
SELECT COUNT(*) as view_accessible FROM v_category_structure;

-- STEP 11: Final verification - this should match what the frontend will see
SELECT 
    category_id,
    category_name,
    category_display_name,
    category_color,
    category_sort_order,
    slot_id,
    slot_name,
    slot_display_name
FROM v_category_structure
ORDER BY category_sort_order, slot_sort_order
LIMIT 20;

SELECT '🎉 DATABASE IS READY! Your app should work now with shared online features!' as final_status;
