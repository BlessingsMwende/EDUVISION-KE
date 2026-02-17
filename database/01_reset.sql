-- 01_reset.sql
-- Purpose: FULL RESET - clears all existing tables/views in public schema.

DO $$
DECLARE r RECORD;
BEGIN
  -- Drop views
  FOR r IN (SELECT table_name FROM information_schema.views WHERE table_schema = 'public')
  LOOP
    EXECUTE 'DROP VIEW IF EXISTS public.' || quote_ident(r.table_name) || ' CASCADE';
  END LOOP;

  -- Drop tables
  FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public')
  LOOP
    EXECUTE 'DROP TABLE IF EXISTS public.' || quote_ident(r.tablename) || ' CASCADE';
  END LOOP;
END $$;
