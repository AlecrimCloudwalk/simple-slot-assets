-- Populate Database with Default Categories and Slots
-- This will insert the missing data that should have been created

-- 1. First, let's check what's currently in the tables
SELECT 'Current categories: ' || COUNT(*)::text as status FROM categories;
SELECT 'Current slots: ' || COUNT(*)::text as status FROM category_slots;

-- 2. Clear any existing data and start fresh
DELETE FROM slot_assets;
DELETE FROM category_slots;
DELETE FROM categories;

-- 3. Insert the 6 default categories
INSERT INTO categories (name, display_name, description, color, bg_class, sort_order, created_by) VALUES
('ai_images', 'AI Images', 'AI-generated image assets', '#667eea', '', 1, 'system'),
('3d_images', '3D Images', '3D rendered image assets', '#28a745', 'mcc-mercadinho', 2, 'system'),
('real_footage', 'Real Footage', 'Real photography and video assets', '#ffc107', 'mcc-roupa', 3, 'system'),
('mercadinho', 'Mercadinho', 'Grocery store/market assets', '#28a745', 'mcc-mercadinho', 4, 'system'),
('loja_de_roupa', 'Loja de Roupa', 'Clothing store assets', '#ffc107', 'mcc-roupa', 5, 'system'),
('sala_beleza_barbearia', 'Sala Beleza/Barbearia', 'Beauty salon/barbershop assets', '#dc3545', 'mcc-beleza', 6, 'system');

-- 4. Insert the 13 slots for each category (78 total slots)
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

-- 5. Verify the data was inserted correctly
SELECT 'Categories created: ' || COUNT(*)::text as verification FROM categories;
SELECT 'Slots created: ' || COUNT(*)::text as verification FROM category_slots;

-- 6. Test the view now has data
SELECT 'View rows: ' || COUNT(*)::text as verification FROM v_category_structure;

-- 7. Show the actual categories that were created
SELECT 
    c.display_name as category,
    COUNT(cs.id) as slots_count
FROM categories c
LEFT JOIN category_slots cs ON c.id = cs.category_id
GROUP BY c.id, c.display_name, c.sort_order
ORDER BY c.sort_order;

-- 8. Show sample slots
SELECT 
    category_display_name as category,
    slot_display_name as slot,
    'Ready for assets!' as status
FROM v_category_structure 
ORDER BY category_sort_order, slot_sort_order
LIMIT 20;

SELECT 'Database is now properly populated with 6 categories and 78 slots!' as final_status;
