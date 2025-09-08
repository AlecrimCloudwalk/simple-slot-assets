-- Fix RLS Performance Issues
-- Replace direct auth.uid() calls with optimized scalar subqueries
-- This prevents per-row re-evaluation and improves query performance

-- =============================================
-- SLOT_ASSETS TABLE RLS OPTIMIZATION
-- =============================================

-- Drop existing inefficient policies
DROP POLICY IF EXISTS "CloudWalk users can insert slot assets" ON public.slot_assets;
DROP POLICY IF EXISTS "CloudWalk users can view slot assets" ON public.slot_assets;
DROP POLICY IF EXISTS "CloudWalk users can update slot assets" ON public.slot_assets;
DROP POLICY IF EXISTS "CloudWalk users can delete slot assets" ON public.slot_assets;

-- Create optimized policies using scalar subqueries
-- This evaluates auth.uid() once per statement instead of per row

CREATE POLICY "CloudWalk users can insert slot assets"
ON public.slot_assets
FOR INSERT TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can view slot assets" 
ON public.slot_assets
FOR SELECT TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can update slot assets"
ON public.slot_assets  
FOR UPDATE TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can delete slot assets"
ON public.slot_assets
FOR DELETE TO authenticated  
USING ((SELECT auth.uid()) IS NOT NULL);

-- =============================================
-- CATEGORIES TABLE RLS OPTIMIZATION  
-- =============================================

-- Drop existing policies if any
DROP POLICY IF EXISTS "CloudWalk users can view categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can insert categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can update categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can delete categories" ON public.categories;

-- Create optimized policies
CREATE POLICY "CloudWalk users can view categories"
ON public.categories
FOR SELECT TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can insert categories"
ON public.categories
FOR INSERT TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can update categories"
ON public.categories
FOR UPDATE TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can delete categories"
ON public.categories
FOR DELETE TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

-- =============================================
-- CATEGORY_SLOTS TABLE RLS OPTIMIZATION
-- =============================================

-- Drop existing policies if any
DROP POLICY IF EXISTS "CloudWalk users can view category slots" ON public.category_slots;
DROP POLICY IF EXISTS "CloudWalk users can insert category slots" ON public.category_slots;
DROP POLICY IF EXISTS "CloudWalk users can update category slots" ON public.category_slots;
DROP POLICY IF EXISTS "CloudWalk users can delete category slots" ON public.category_slots;

-- Create optimized policies
CREATE POLICY "CloudWalk users can view category slots"
ON public.category_slots
FOR SELECT TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can insert category slots"
ON public.category_slots
FOR INSERT TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can update category slots"
ON public.category_slots
FOR UPDATE TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "CloudWalk users can delete category slots"
ON public.category_slots
FOR DELETE TO authenticated
USING ((SELECT auth.uid()) IS NOT NULL);

-- =============================================
-- VERIFY RLS IS ENABLED
-- =============================================

-- Ensure RLS is enabled on all tables
ALTER TABLE public.slot_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;  
ALTER TABLE public.category_slots ENABLE ROW LEVEL SECURITY;

-- =============================================
-- TEST QUERIES FOR VERIFICATION
-- =============================================

-- Test that policies work correctly
-- Run these after applying the fix to verify performance

-- Test slot_assets (should be fast now)
SELECT COUNT(*) FROM public.slot_assets;

-- Test categories (should be fast)  
SELECT COUNT(*) FROM public.categories;

-- Test category_slots (should be fast)
SELECT COUNT(*) FROM public.category_slots;

-- Check policy definitions
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('slot_assets', 'categories', 'category_slots')
ORDER BY tablename, policyname;
