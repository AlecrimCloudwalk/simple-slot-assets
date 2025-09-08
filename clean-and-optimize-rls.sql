-- Complete RLS Cleanup and Optimization
-- Removes ALL existing policies and creates only optimized ones

-- =============================================
-- COMPLETE POLICY CLEANUP
-- =============================================

-- Remove ALL existing policies (including duplicates)
DO $$
DECLARE
    policy_record RECORD;
BEGIN
    -- Drop all policies on slot_assets
    FOR policy_record IN 
        SELECT policyname FROM pg_policies WHERE tablename = 'slot_assets'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.slot_assets', policy_record.policyname);
        RAISE NOTICE 'Dropped policy: %', policy_record.policyname;
    END LOOP;
    
    -- Drop all policies on categories  
    FOR policy_record IN 
        SELECT policyname FROM pg_policies WHERE tablename = 'categories'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.categories', policy_record.policyname);
        RAISE NOTICE 'Dropped policy: %', policy_record.policyname;
    END LOOP;
    
    -- Drop all policies on category_slots
    FOR policy_record IN 
        SELECT policyname FROM pg_policies WHERE tablename = 'category_slots'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.category_slots', policy_record.policyname);
        RAISE NOTICE 'Dropped policy: %', policy_record.policyname;
    END LOOP;
    
    RAISE NOTICE 'All policies cleaned up successfully';
END $$;

-- =============================================
-- VERIFY ALL POLICIES ARE GONE
-- =============================================

SELECT 
  'After cleanup - should be 0:' as status,
  COUNT(*) as remaining_policies
FROM pg_policies 
WHERE tablename IN ('slot_assets', 'categories', 'category_slots');

-- =============================================
-- CREATE OPTIMIZED CLOUDWALK-ONLY POLICIES
-- =============================================

-- SLOT_ASSETS - Optimized policies only
CREATE POLICY "CloudWalk users can view slot assets"
ON public.slot_assets
FOR SELECT TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can insert slot assets"
ON public.slot_assets
FOR INSERT TO authenticated
WITH CHECK ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can update slot assets"
ON public.slot_assets
FOR UPDATE TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io')
WITH CHECK ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can delete slot assets"
ON public.slot_assets
FOR DELETE TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io');

-- CATEGORIES - Optimized policies only
CREATE POLICY "CloudWalk users can view categories"
ON public.categories
FOR SELECT TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can insert categories"
ON public.categories
FOR INSERT TO authenticated
WITH CHECK ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can update categories"
ON public.categories
FOR UPDATE TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io')
WITH CHECK ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can delete categories"
ON public.categories
FOR DELETE TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io');

-- CATEGORY_SLOTS - Optimized policies only
CREATE POLICY "CloudWalk users can view category slots"
ON public.category_slots
FOR SELECT TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can insert category slots"
ON public.category_slots
FOR INSERT TO authenticated
WITH CHECK ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can update category slots"
ON public.category_slots
FOR UPDATE TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io')
WITH CHECK ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can delete category slots"
ON public.category_slots
FOR DELETE TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io');

-- =============================================
-- ENSURE RLS IS ENABLED
-- =============================================

ALTER TABLE public.slot_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.category_slots ENABLE ROW LEVEL SECURITY;

-- =============================================
-- VERIFY OPTIMIZATION SUCCESS
-- =============================================

SELECT 
  'After optimization:' as status,
  COUNT(*) as total_policies
FROM pg_policies 
WHERE tablename IN ('slot_assets', 'categories', 'category_slots');

-- Check that ALL policies are now optimized
SELECT 
  tablename,
  policyname,
  cmd as operation,
  CASE 
    WHEN qual LIKE '%(SELECT auth.email())%' OR with_check LIKE '%(SELECT auth.email())%' THEN '✅ OPTIMIZED'
    WHEN qual LIKE '%auth.email()%' OR with_check LIKE '%auth.email()%' THEN '❌ NEEDS OPTIMIZATION' 
    ELSE '⚠️ OTHER'
  END as performance_status,
  -- Show the actual policy condition for verification
  COALESCE(qual, with_check) as policy_condition
FROM pg_policies 
WHERE tablename IN ('slot_assets', 'categories', 'category_slots')
ORDER BY tablename, policyname;

-- =============================================
-- FINAL SUCCESS MESSAGE
-- =============================================

SELECT 
  '🎉 RLS optimization complete!' as message,
  'All policies now use (SELECT auth.email()) for optimal performance' as details;
