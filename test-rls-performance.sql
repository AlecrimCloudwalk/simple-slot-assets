-- Test RLS Performance Before and After Optimization
-- Run this before applying fixes to see the performance issue
-- Then run after applying fixes to verify improvement

-- =============================================
-- PERFORMANCE BASELINE TEST
-- =============================================

-- Check current RLS policies
SELECT 
    schemaname,
    tablename, 
    policyname,
    cmd,
    qual as using_clause,
    with_check as with_check_clause
FROM pg_policies 
WHERE tablename IN ('slot_assets', 'categories', 'category_slots')
ORDER BY tablename, policyname;

-- =============================================
-- TIMING TESTS (run with \timing in psql)
-- =============================================

-- Test slot_assets performance (likely slow if RLS is inefficient)
\timing on
SELECT COUNT(*) FROM public.slot_assets;
\timing off

-- Test categories performance  
\timing on
SELECT COUNT(*) FROM public.categories;
\timing off

-- Test category_slots performance
\timing on  
SELECT COUNT(*) FROM public.category_slots;
\timing off

-- Test actual data retrieval (what the app does)
\timing on
SELECT id, slot_name FROM public.slot_assets LIMIT 10;
\timing off

\timing on
SELECT id, name, display_name FROM public.categories LIMIT 10;
\timing off

\timing on
SELECT id, category_id, slot_name FROM public.category_slots LIMIT 10;
\timing off

-- =============================================
-- EXPLAIN ANALYZE TESTS
-- =============================================

-- See query plans to identify RLS overhead
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM public.slot_assets;

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, slot_name FROM public.slot_assets LIMIT 10;

-- =============================================
-- AUTH FUNCTION EVALUATION TEST  
-- =============================================

-- This shows how many times auth functions are called
-- Look for high "loops" count in EXPLAIN output

-- Test with current policies (likely inefficient)
EXPLAIN (ANALYZE, VERBOSE, BUFFERS)
SELECT id FROM public.slot_assets LIMIT 1;

-- =============================================
-- EXPECTED RESULTS
-- =============================================

/*
BEFORE FIX (inefficient RLS):
- Queries may take 2-8+ seconds
- EXPLAIN shows auth.uid() evaluated per row  
- High CPU usage for simple queries
- Timeouts in browser application

AFTER FIX (optimized RLS):
- Queries should complete in <100ms
- EXPLAIN shows (SELECT auth.uid()) evaluated once
- Low CPU usage
- No timeouts in browser application

Key indicators of RLS performance issues:
1. Query time increases with table size
2. EXPLAIN shows function evaluation per row
3. Browser queries timeout after 8 seconds
4. Simple COUNT(*) queries are slow
*/
