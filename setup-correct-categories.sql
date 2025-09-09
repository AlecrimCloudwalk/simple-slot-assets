-- Setup correct category structure for CloudWalk Asset Manager
-- Categories represent visual styles/themes
-- All categories will use the same predefined slots (handled by app)

-- Clear existing data first
DELETE FROM public.category_slots;
DELETE FROM public.categories;

-- Insert style-based categories
INSERT INTO public.categories (name, display_name, description, color, bg_class, sort_order, is_active, created_by) VALUES
    ('ai_images', 'AI Images', 'Banners created with artificial intelligence', '#667eea', 'bg-indigo-500', 1, true, auth.uid()),
    ('real_footage', 'Real Footage', 'Banners with real photography', '#28a745', 'bg-green-500', 2, true, auth.uid()),
    ('bakery', 'Bakery', 'Style for bakery businesses', '#ffc107', 'bg-yellow-500', 3, true, auth.uid()),
    ('beauty_salon', 'Beauty Salon', 'Style for beauty and salon businesses', '#e83e8c', 'bg-pink-500', 4, true, auth.uid()),
    ('3d_images', '3D Images', 'Banners with 3D rendered graphics', '#6f42c1', 'bg-purple-500', 5, true, auth.uid()),
    ('minimalist', 'Minimalist', 'Clean and simple design style', '#6c757d', 'bg-gray-500', 6, true, auth.uid()),
    ('corporate', 'Corporate', 'Professional business style', '#007bff', 'bg-blue-500', 7, true, auth.uid()),
    ('vintage', 'Vintage', 'Retro and classic design style', '#fd7e14', 'bg-orange-500', 8, true, auth.uid())
ON CONFLICT (name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    description = EXCLUDED.description,
    color = EXCLUDED.color,
    bg_class = EXCLUDED.bg_class,
    sort_order = EXCLUDED.sort_order,
    is_active = EXCLUDED.is_active,
    updated_at = NOW();

-- Note: Slots are now handled by the application using PREDEFINED_SLOTS
-- All categories automatically get the same set of 13 slots (matching video filenames):
-- - checkout
-- - create_bill
-- - dirf  
-- - infinite_card
-- - infinite_cash_can_request_limit
-- - infinite_cash
-- - instant_settlement
-- - pay_bill
-- - piselli
-- - pix_credit
-- - referral
-- - supercobra
-- - tap

-- Each slot has Portuguese descriptions and pretty display names defined in the app:
-- Example: 'checkout' displays as "Checkout" with description "Finalize suas compras com facilidade"

-- Verify the setup
SELECT 
    id, 
    name, 
    display_name, 
    color, 
    bg_class, 
    sort_order, 
    is_active 
FROM public.categories 
ORDER BY sort_order;
