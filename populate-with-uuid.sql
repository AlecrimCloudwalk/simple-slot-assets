-- Populate Initial Data with Specific User UUID
-- STEP 1: Replace 'YOUR_USER_UUID_HERE' with your actual UUID from auth.users table
-- STEP 2: Run this script in Supabase SQL Editor

-- Get your user UUID first:
SELECT 
    'Your User UUID is:' as info,
    id as user_uuid,
    email
FROM auth.users 
WHERE email LIKE '%@cloudwalk.io'
ORDER BY created_at DESC
LIMIT 1;

-- REPLACE 'YOUR_USER_UUID_HERE' with the UUID from above query before running the rest!

-- =============================================
-- INSERT SAMPLE CATEGORIES
-- =============================================

INSERT INTO public.categories (name, display_name, created_by, color, bg_class, sort_order, is_active) VALUES
('checkout', 'Checkout', 'YOUR_USER_UUID_HERE', '#4F46E5', 'bg-indigo-500', 1, true),
('create_bill', 'Create Bill', 'YOUR_USER_UUID_HERE', '#059669', 'bg-emerald-600', 2, true),
('dirf', 'DIRF', 'YOUR_USER_UUID_HERE', '#DC2626', 'bg-red-600', 3, true),
('infinite_card', 'Infinite Card', 'YOUR_USER_UUID_HERE', '#7C3AED', 'bg-violet-600', 4, true),
('infinite_cash', 'Infinite Cash', 'YOUR_USER_UUID_HERE', '#EA580C', 'bg-orange-600', 5, true),
('infinite_cash_limit', 'Cash Limit Request', 'YOUR_USER_UUID_HERE', '#D97706', 'bg-amber-600', 6, true),
('instant_settlement', 'Instant Settlement', 'YOUR_USER_UUID_HERE', '#0D9488', 'bg-teal-600', 7, true),
('pay_bill', 'Pay Bill', 'YOUR_USER_UUID_HERE', '#0EA5E9', 'bg-sky-500', 8, true),
('piselli', 'Piselli', 'YOUR_USER_UUID_HERE', '#EC4899', 'bg-pink-500', 9, true),
('pix_credit', 'PIX Credit', 'YOUR_USER_UUID_HERE', '#10B981', 'bg-emerald-500', 10, true),
('referral', 'Referral Program', 'YOUR_USER_UUID_HERE', '#8B5CF6', 'bg-purple-500', 11, true),
('supercobra', 'Super Cobra', 'YOUR_USER_UUID_HERE', '#F59E0B', 'bg-yellow-500', 12, true),
('tap', 'Tap to Pay', 'YOUR_USER_UUID_HERE', '#EF4444', 'bg-red-500', 13, true)
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
('app_assets_videos_banners_v2_checkout', 'Checkout Experience', 'Streamlined checkout process for CloudWalk payments', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_checkout.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_create_bill', 'Bill Creation', 'Create and manage bills with ease', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_create_bill.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_dirf', 'DIRF Management', 'Annual tax declaration reporting', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_dirf.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_infinite_card', 'Infinite Card', 'Premium card with unlimited benefits', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_infinite_card.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_infinite_cash_can_request_limit', 'Cash Limit Increase', 'Request higher cash withdrawal limits', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_infinite_cash_can_request_limit.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_infinite_cash', 'Infinite Cash', 'Instant cash advances when you need them', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_infinite_cash.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_instant_settlement', 'Instant Settlement', 'Get your money in seconds, not days', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_instant_settlement.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_pay_bill', 'Bill Payment', 'Pay any bill quickly and securely', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_pay_bill.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_piselli', 'Piselli Integration', 'Advanced payment processing features', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_piselli.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_pix_credit', 'PIX Credit', 'Instant credit via PIX payments', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_pix_credit.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_referral', 'Referral Program', 'Earn rewards by referring friends', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_referral.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_supercobra', 'Super Cobra', 'Advanced analytics and reporting', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_supercobra.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW()),
('app_assets_videos_banners_v2_tap', 'Tap to Pay', 'Contactless payment solution', 'https://github.com/AlecrimCloudwalk/simple-slot-assets/raw/main/example%20folder/app_assets_videos_banners_v2_tap.mp4', 'YOUR_USER_UUID_HERE', NOW(), NOW())
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
  'YOUR_USER_UUID_HERE',
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

SELECT 'Categories created:' as status, COUNT(*) as count FROM categories WHERE is_active = true;
SELECT 'Slot assets created:' as status, COUNT(*) as count FROM slot_assets;
SELECT 'Category-slot mappings:' as status, COUNT(*) as count FROM category_slots;

-- Final success message
SELECT '🎉 Data population complete!' as message;
