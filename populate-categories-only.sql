-- Populate Categories Only (Fixed for Current Schema)
-- Run this in Supabase SQL Editor
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
-- VERIFICATION QUERIES
-- =============================================

-- Verify categories were created
SELECT 
  'Categories created:' as status,
  COUNT(*) as count,
  STRING_AGG(display_name, ', ' ORDER BY sort_order) as categories
FROM categories 
WHERE is_active = true;

-- Show all categories
SELECT 
  id,
  name,
  display_name,
  color,
  sort_order,
  is_active
FROM categories 
ORDER BY sort_order;

-- Final message
SELECT 
  '🎉 Categories setup complete!' as message,
  'slot_assets table appears to be for file uploads - use the app to upload videos' as note,
  'Refresh your web app to see the category tabs' as next_step;
