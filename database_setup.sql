-- Database Setup for TISB Swap App
-- Run this in your Supabase SQL Editor (Dashboard > SQL Editor)
-- This sets up the profiles table and RLS policies
-- Note: Profile creation is handled by the app code, not a database trigger

-- 1. Create the profiles table (if it doesn't exist)
-- Note: You mentioned you already have this table, so you can skip this if it exists
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid NOT NULL,
  full_name text NULL,
  email text NULL,
  avatar_url text NULL,
  points integer NULL DEFAULT 0,
  co2_saved double precision NULL DEFAULT 0.0,
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_email_key UNIQUE (email),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE
) TABLESPACE pg_default;

-- 2. Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 3. Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can view other profiles" ON public.profiles;

-- 4. Create RLS Policies

-- Policy: Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON public.profiles
  FOR SELECT
  USING (auth.uid() = id);

-- Policy: Users can insert their own profile
-- This is needed for the app to create profiles after signup
-- Users can only insert profiles where the id matches their auth.uid()
CREATE POLICY "Users can insert own profile"
  ON public.profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON public.profiles
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Policy: Authenticated users can view other users' profiles (for marketplace, etc.)
CREATE POLICY "Users can view other profiles"
  ON public.profiles
  FOR SELECT
  USING (auth.role() = 'authenticated');

-- 5. Remove any existing trigger and function (if they exist)
-- NOTE: We're NOT using a trigger because profile creation is handled in the app code
-- This prevents the "control reached end of trigger procedure without RETURN" error
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- Note: Profile creation is handled in lib/services/supabase_service.dart
-- The app code creates profiles after successful signup using upsert()
-- This gives better error handling and control than a database trigger

-- 6. Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON public.profiles TO anon, authenticated;

-- 7. Important Notes:
--    - Profile creation is handled by the app code (lib/services/supabase_service.dart)
--    - The RLS policies allow users to insert their own profiles after signup
--    - The "Users can insert own profile" policy allows inserts when auth.uid() = id
--    - This works because the user has a session when the app creates the profile

-- Verification queries (run these to check if everything is set up correctly):
-- SELECT * FROM public.profiles; -- Should show existing profiles
-- SELECT * FROM pg_policies WHERE tablename = 'profiles'; -- Should show 4 policies

