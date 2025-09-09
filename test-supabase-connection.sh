#!/bin/bash

# Test Supabase Connection Script
# This tests your Supabase connection without the SDK

echo "🔍 Testing Supabase Connection..."
echo ""

SUPABASE_URL="https://gouolvsfxrupayzmmomj.supabase.co"
SUPABASE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdvdW9sdnNmeHJ1cGF5em1tb21qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5MzIxMjAsImV4cCI6MjA3MjUwODEyMH0.QsIG3xo5rqOKoiTEbIuzf8_IutgEglJPUiOeFXJQUj4"

echo "🌐 Testing basic connectivity to Supabase..."
if curl -s --connect-timeout 10 "$SUPABASE_URL" > /dev/null; then
    echo "✅ Basic connection to Supabase successful"
else
    echo "❌ Cannot connect to Supabase at all"
    exit 1
fi

echo ""
echo "🔍 Testing REST API endpoint..."
response=$(curl -s -w "%{http_code}" \
    -H "Authorization: Bearer $SUPABASE_KEY" \
    -H "apikey: $SUPABASE_KEY" \
    -H "Content-Type: application/json" \
    "$SUPABASE_URL/rest/v1/categories?limit=5" 2>/dev/null)

status_code="${response: -3}"
body="${response%???}"

echo "Status Code: $status_code"

if [ "$status_code" = "200" ]; then
    echo "✅ REST API call successful!"
    echo "Response: $body"
    
    # Count items
    count=$(echo "$body" | grep -o '\[.*\]' | grep -o '{' | wc -l | tr -d ' ')
    echo "Categories found: $count"
    
elif [ "$status_code" = "401" ]; then
    echo "❌ Authentication failed - RLS may be blocking"
    echo "Suggestion: Disable RLS temporarily with:"
    echo "   ALTER TABLE public.categories DISABLE ROW LEVEL SECURITY;"
    
elif [ "$status_code" = "404" ]; then
    echo "❌ Table not found"
    echo "Categories table may not exist"
    
else
    echo "❌ Request failed with status $status_code"
    echo "Response: $body"
fi

echo ""
echo "🔍 Testing health endpoint..."
health_response=$(curl -s -w "%{http_code}" \
    -H "Authorization: Bearer $SUPABASE_KEY" \
    -H "apikey: $SUPABASE_KEY" \
    "$SUPABASE_URL/rest/v1/" 2>/dev/null)

health_status="${health_response: -3}"
if [ "$health_status" = "200" ]; then
    echo "✅ Supabase REST API is healthy"
else
    echo "❌ Supabase REST API health check failed: $health_status"
fi

echo ""
echo "🎯 Summary:"
echo "If you see 401 errors, run this in Supabase SQL Editor:"
echo "   ALTER TABLE public.categories DISABLE ROW LEVEL SECURITY;"
echo ""
echo "If you see timeouts, the issue is network connectivity."
echo "If you see 200 with data, the issue is in the JavaScript SDK."
