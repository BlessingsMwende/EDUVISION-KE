-- 02_national_backbone.sql
-- Purpose: Create core national education structure.
-- Counties → Schools → Learners → Enrollments

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1) Counties
CREATE TABLE counties (
  county_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT UNIQUE NOT NULL
);

-- 2) Schools
CREATE TABLE schools (
  school_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nemis_code TEXT UNIQUE,
  name TEXT NOT NULL,
  county_id UUID REFERENCES counties(county_id),
  sub_county TEXT,
  ward TEXT,
  status TEXT DEFAULT 'Active',
  created_at TIMESTAMP DEFAULT NOW()
);

-- 3) Learners
CREATE TABLE learners (
  learner_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  gender TEXT,
  dob DATE,
  county_id UUID REFERENCES counties(county_id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4) Enrollments
CREATE TABLE enrollments (
  enrollment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  learner_id UUID NOT NULL REFERENCES learners(learner_id),
  school_id UUID NOT NULL REFERENCES schools(school_id),
  grade_level TEXT NOT NULL,
  term TEXT NOT NULL,
  status TEXT DEFAULT 'Enrolled',
  enrolled_at TIMESTAMP DEFAULT NOW()
);

-- Performance indexes
CREATE INDEX idx_schools_county ON schools(county_id);
CREATE INDEX idx_learners_county ON learners(county_id);
CREATE INDEX idx_enrollments_term ON enrollments(term);
CREATE INDEX idx_enrollments_school_term ON enrollments(school_id, term);
