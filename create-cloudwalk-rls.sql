-- Create CloudWalk Domain-Restricted RLS Policies (SQL Editor Safe)
-- This version just creates the optimized policies without testing auth context
-- Run this in Supabase SQL Editor - the "DENIED" message is normal there

-- =============================================
-- SLOT_ASSETS TABLE - CLOUDWALK DOMAIN ONLY
-- =============================================

-- Drop existing policies
DROP POLICY IF EXISTS "CloudWalk users can insert slot assets" ON public.slot_assets;
DROP POLICY IF EXISTS "CloudWalk users can view slot assets" ON public.slot_assets;
DROP POLICY IF EXISTS "CloudWalk users can update slot assets" ON public.slot_assets;
DROP POLICY IF EXISTS "CloudWalk users can delete slot assets" ON public.slot_assets;

-- Create optimized CloudWalk-only policies
CREATE POLICY "CloudWalk users can view slot assets"
ON public.slot_assets
FOR SELECT TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can insert slot assets"
ON public.slot_assets
FOR INSERT TO authenticated
WITH CHECK (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can update slot assets"
ON public.slot_assets
FOR UPDATE TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
)
WITH CHECK (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can delete slot assets"
ON public.slot_assets
FOR DELETE TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

-- =============================================
-- CATEGORIES TABLE - CLOUDWALK DOMAIN ONLY
-- =============================================

-- Drop existing policies
DROP POLICY IF EXISTS "CloudWalk users can view categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can insert categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can update categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can delete categories" ON public.categories;

-- Create optimized CloudWalk-only policies
CREATE POLICY "CloudWalk users can view categories"
ON public.categories
FOR SELECT TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can insert categories"
ON public.categories
FOR INSERT TO authenticated
WITH CHECK (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can update categories"
ON public.categories
FOR UPDATE TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
)
WITH CHECK (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can delete categories"
ON public.categories
FOR DELETE TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

-- =============================================
-- CATEGORY_SLOTS TABLE - CLOUDWALK DOMAIN ONLY
-- =============================================

-- Drop existing policies
DROP POLICY IF EXISTS "CloudWalk users can view category slots" ON public.category_slots;
DROP POLICY IF EXISTS "CloudWalk users can insert category slots" ON public.category_slots;
DROP POLICY IF EXISTS "CloudWalk users can update category slots" ON public.category_slots;
DROP POLICY IF EXISTS "CloudWalk users can delete category slots" ON public.category_slots;

-- Create optimized CloudWalk-only policies
CREATE POLICY "CloudWalk users can view category slots"
ON public.category_slots
FOR SELECT TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can insert category slots"
ON public.category_slots
FOR INSERT TO authenticated
WITH CHECK (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can update category slots"
ON public.category_slots
FOR UPDATE TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
)
WITH CHECK (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

CREATE POLICY "CloudWalk users can delete category slots"
ON public.category_slots
FOR DELETE TO authenticated
USING (
  (SELECT auth.email()) LIKE '%@cloudwalk.io'
);

-- =============================================
-- ENABLE RLS ON ALL TABLES
-- =============================================

ALTER TABLE public.slot_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.category_slots ENABLE ROW LEVEL SECURITY;

-- =============================================
-- VERIFY POLICIES WERE CREATED
-- =============================================

SELECT 
  'Policies created successfully!' as status,
  COUNT(*) as policy_count
FROM pg_policies 
WHERE tablename IN ('slot_assets', 'categories', 'category_slots');

-- Show all created policies
SELECT 
  tablename,
  policyname,
  cmd as operation,
  CASE 
    WHEN qual LIKE '%(SELECT auth.email())%' THEN 'OPTIMIZED (uses scalar subquery)'
    WHEN qual LIKE '%auth.email()%' THEN 'NEEDS OPTIMIZATION'
    ELSE 'OTHER'
  END as performance_status
FROM pg_policies 
WHERE tablename IN ('slot_assets', 'categories', 'category_slots')
ORDER BY tablename, policyname;
