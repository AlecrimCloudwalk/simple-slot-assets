-- Populate Initial Data - Ready to Run
-- UUID: 2b42f2d0-67be-40a3-bb3b-6e1b57917bc7 (alecrim@cloudwalk.io)

-- =============================================
-- INSERT SAMPLE CATEGORIES
-- =============================================

INSERT INTO public.categories (name, display_name, created_by, color, bg_class, sort_order, is_active) VALUES
('checkout', 'Checkout', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#4F46E5', 'bg-indigo-500', 1, true),
('create_bill', 'Create Bill', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#059669', 'bg-emerald-600', 2, true),
('dirf', 'DIRF', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#DC2626', 'bg-red-600', 3, true),
('infinite_card', 'Infinite Card', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#7C3AED', 'bg-violet-600', 4, true),
('infinite_cash', 'Infinite Cash', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#EA580C', 'bg-orange-600', 5, true),
('infinite_cash_limit', 'Cash Limit Request', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#D97706', 'bg-amber-600', 6, true),
('instant_settlement', 'Instant Settlement', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#0D9488', 'bg-teal-600', 7, true),
('pay_bill', 'Pay Bill', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#0EA5E9', 'bg-sky-500', 8, true),
('piselli', 'Piselli', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#EC4899', 'bg-pink-500', 9, true),
('pix_credit', 'PIX Credit', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#10B981', 'bg-emerald-500', 10, true),
('referral', 'Referral Program', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#8B5CF6', 'bg-purple-500', 11, true),
('supercobra', 'Super Cobra', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#F59E0B', 'bg-yellow-500', 12, true),
('tap', 'Tap to Pay', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', '#EF4444', 'bg-red-500', 13, true)
ON CONFLICT (name) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  created_by = EXCLUDED.created_by,
  color = EXCLUDED.color,
  bg_class = EXCLUDED.bg_class,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

-- =============================================
-- INSERT SAMPLE SLOT ASSETS
-- =============================================

INSERT INTO public.slot_assets (name, title, description, video_url, created_by, created_at, updated_at) VALUES
('app_assets_videos_banners_v2_checkout', 'Checkout Experience', 'Streamlined checkout process for CloudWalk payments', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_checkout.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_create_bill', 'Bill Creation', 'Create and manage bills with ease', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_create_bill.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_dirf', 'DIRF Management', 'Annual tax declaration reporting', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_dirf.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_infinite_card', 'Infinite Card', 'Premium card with unlimited benefits', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_infinite_card.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_infinite_cash_can_request_limit', 'Cash Limit Increase', 'Request higher cash withdrawal limits', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_infinite_cash_can_request_limit.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_infinite_cash', 'Infinite Cash', 'Instant cash advances when you need them', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_infinite_cash.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_instant_settlement', 'Instant Settlement', 'Get your money in seconds, not days', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_instant_settlement.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_pay_bill', 'Bill Payment', 'Pay any bill quickly and securely', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_pay_bill.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_piselli', 'Piselli Integration', 'Advanced payment processing features', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_piselli.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_pix_credit', 'PIX Credit', 'Instant credit via PIX payments', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_pix_credit.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_referral', 'Referral Program', 'Earn rewards by referring friends', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_referral.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_supercobra', 'Super Cobra', 'Advanced analytics and reporting', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_supercobra.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW()),
('app_assets_videos_banners_v2_tap', 'Tap to Pay', 'Contactless payment solution', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_tap.mp4', '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  video_url = EXCLUDED.video_url,
  created_by = EXCLUDED.created_by,
  updated_at = NOW();

-- =============================================
-- LINK CATEGORIES TO SLOT ASSETS
-- =============================================

-- Create category-slot mappings
WITH category_mappings AS (
  SELECT 
    c.id as category_id,
    c.name as category_name,
    s.id as slot_id,
    s.name as slot_name
  FROM categories c
  CROSS JOIN slot_assets s
  WHERE 
    -- Map slots to categories based on naming convention
    (c.name = 'checkout' AND s.name LIKE '%checkout%') OR
    (c.name = 'create_bill' AND s.name LIKE '%create_bill%') OR
    (c.name = 'dirf' AND s.name LIKE '%dirf%') OR
    (c.name = 'infinite_card' AND s.name LIKE '%infinite_card%') OR
    (c.name = 'infinite_cash' AND s.name LIKE '%infinite_cash%' AND s.name NOT LIKE '%can_request_limit%') OR
    (c.name = 'infinite_cash_limit' AND s.name LIKE '%can_request_limit%') OR
    (c.name = 'instant_settlement' AND s.name LIKE '%instant_settlement%') OR
    (c.name = 'pay_bill' AND s.name LIKE '%pay_bill%') OR
    (c.name = 'piselli' AND s.name LIKE '%piselli%') OR
    (c.name = 'pix_credit' AND s.name LIKE '%pix_credit%') OR
    (c.name = 'referral' AND s.name LIKE '%referral%') OR
    (c.name = 'supercobra' AND s.name LIKE '%supercobra%') OR
    (c.name = 'tap' AND s.name LIKE '%tap%')
)
INSERT INTO public.category_slots (category_id, slot_asset_id, sort_order, created_by, created_at, updated_at)
SELECT 
  category_id,
  slot_id,
  1, -- sort_order
  '2b42f2d0-67be-40a3-bb3b-6e1b57917bc7',
  NOW(),
  NOW()
FROM category_mappings
ON CONFLICT (category_id, slot_asset_id) DO UPDATE SET
  sort_order = EXCLUDED.sort_order,
  created_by = EXCLUDED.created_by,
  updated_at = NOW();

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- Verify categories were created
SELECT 
  'Categories created:' as status,
  COUNT(*) as count,
  STRING_AGG(display_name, ', ' ORDER BY sort_order) as categories
FROM categories 
WHERE is_active = true;

-- Verify slot assets were created
SELECT 
  'Slot assets created:' as status,
  COUNT(*) as count
FROM slot_assets;

-- Verify category-slot mappings
SELECT 
  'Category-slot mappings:' as status,
  COUNT(*) as count
FROM category_slots cs
JOIN categories c ON c.id = cs.category_id
JOIN slot_assets s ON s.id = cs.slot_asset_id;

-- Show sample of what was created
SELECT 
  c.display_name as category,
  s.title as slot_title
FROM category_slots cs
JOIN categories c ON c.id = cs.category_id  
JOIN slot_assets s ON s.id = cs.slot_asset_id
ORDER BY c.sort_order, s.title
LIMIT 10;

-- Final success message
SELECT 
  '🎉 Initial data setup complete!' as message,
  'Refresh your web app to see the categories and slots' as next_step;
