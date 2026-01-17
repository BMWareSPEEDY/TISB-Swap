-- Function to check if user email domain is allowed
-- This restricts signups to TISB email domains only
-- Run this in Supabase SQL Editor

CREATE OR REPLACE FUNCTION public.check_user_domain(email_address TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  allowed_domains TEXT[] := ARRAY[
    'tisb.ac.in',
    'student.tisb.ac.in',
    'staff.tisb.ac.in',
    'faculty.tisb.ac.in'
  ];
  email_domain TEXT;
BEGIN
  -- Extract domain from email (everything after @)
  email_domain := LOWER(SPLIT_PART(email_address, '@', 2));
  
  -- Check if domain is in allowed list
  RETURN email_domain = ANY(allowed_domains);
EXCEPTION
  WHEN OTHERS THEN
    -- If email format is invalid, return false
    RETURN FALSE;
END;
$$;

-- Example usage in a check constraint or trigger:
-- This would prevent signups with non-TISB emails
-- (You'd add this as a check constraint or use it in a trigger)

-- Alternative: Use this in a database trigger to validate email on signup
CREATE OR REPLACE FUNCTION public.validate_user_email()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if email domain is allowed
  IF NOT public.check_user_domain(NEW.email) THEN
    RAISE EXCEPTION 'Email domain not allowed. Only TISB email addresses (@tisb.ac.in, @student.tisb.ac.in, etc.) are permitted.';
  END IF;
  
  RETURN NEW;
END;
$$;

-- Create trigger to validate email on user creation
-- (Only enable this if you want to enforce domain restrictions at database level)
-- DROP TRIGGER IF EXISTS validate_email_on_signup ON auth.users;
-- CREATE TRIGGER validate_email_on_signup
--   BEFORE INSERT ON auth.users
--   FOR EACH ROW
--   EXECUTE FUNCTION public.validate_user_email();

-- Test the function:
-- SELECT public.check_user_domain('student@student.tisb.ac.in'); -- Should return TRUE
-- SELECT public.check_user_domain('user@gmail.com'); -- Should return FALSE
-- SELECT public.check_user_domain('teacher@tisb.ac.in'); -- Should return TRUE

