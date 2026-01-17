-- QUICK FIX: Remove the problematic trigger
-- Run this FIRST in Supabase SQL Editor to fix the signup error

-- Remove the trigger and function that's causing the error
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- Verify it's gone (should return 0 rows)
SELECT COUNT(*) as trigger_count 
FROM pg_trigger 
WHERE tgname = 'on_auth_user_created';

-- Verify function is gone (should return 0 rows)
SELECT COUNT(*) as function_count 
FROM pg_proc 
WHERE proname = 'handle_new_user';

