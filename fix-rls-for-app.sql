-- Fix RLS Policies for Web App Access
-- Creates RLS policies that work properly with authenticated web app users

-- Re-enable RLS if it was disabled
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.slot_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.category_slots ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to start fresh
DROP POLICY IF EXISTS "CloudWalk users can view categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can insert categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can update categories" ON public.categories;
DROP POLICY IF EXISTS "CloudWalk users can delete categories" ON public.categories;

-- Create proper policies for categories
CREATE POLICY "CloudWalk users can view categories"
ON public.categories
FOR SELECT TO authenticated
USING (
  -- Allow access if user email ends with @cloudwalk.io
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
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io')
WITH CHECK ((SELECT auth.email()) LIKE '%@cloudwalk.io');

CREATE POLICY "CloudWalk users can delete categories"
ON public.categories
FOR DELETE TO authenticated
USING ((SELECT auth.email()) LIKE '%@cloudwalk.io');

-- Test the policies (this will fail in SQL Editor but should work from web app)
SELECT 
  'RLS policies created for authenticated users' as status,
  'Test from web app - SQL Editor will show DENIED (normal)' as note;

-- Show policy information
SELECT 
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies 
WHERE tablename = 'categories';
