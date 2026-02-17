-- ===========================================
-- STEP 5: DATA INTEGRITY & ANOMALY MONITORING
-- Purpose: Detect ghost learners, duplicates, suspicious records
-- ===========================================

-- 1) Integrity flags table (generic flagging across entities)
CREATE TABLE integrity_flags (
    flag_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    entity_type TEXT NOT NULL,     -- Learner / School / Enrollment / Assessment
    entity_id UUID NOT NULL,       -- ID of the entity being flagged

    flag_type TEXT NOT NULL,       -- Duplicate / Ghost / Suspicious Pattern
    severity_level INTEGER NOT NULL DEFAULT 1,  -- 1 (low) to 5 (critical)

    description TEXT,
    evidence JSONB,                -- optional: store supporting data
    status TEXT DEFAULT 'Open',    -- Open / Investigating / Resolved / False Positive

    created_at TIMESTAMP DEFAULT NOW(),
    resolved_at TIMESTAMP
);

-- Helpful indexes
CREATE INDEX idx_integrity_entity ON integrity_flags(entity_type, entity_id);
CREATE INDEX idx_integrity_status ON integrity_flags(status);
CREATE INDEX idx_integrity_severity ON integrity_flags(severity_level);

-- ===========================================
-- OPTIONAL: Views that help detect anomalies
-- (These do not change data; they help analytics)
-- ===========================================

-- A) Possible duplicate learners: same name + DOB + county
-- NOTE: adjust columns if your learners table uses different names
CREATE OR REPLACE VIEW v_possible_duplicate_learners AS
SELECT
  lower(trim(first_name)) AS first_name_norm,
  lower(trim(last_name))  AS last_name_norm,
  dob,
  county_id,
  COUNT(*) AS duplicate_count
FROM learners
WHERE first_name IS NOT NULL AND last_name IS NOT NULL AND dob IS NOT NULL
GROUP BY 1,2,3,4
HAVING COUNT(*) > 1;

-- B) Potential ghost learners:
-- learners with enrollment but no attendance records (example logic)
-- NOTE: This assumes you have attendance + enrollments tables.
-- If not yet created, keep this view but it will fail until those tables exist.
CREATE OR REPLACE VIEW v_potential_ghost_learners AS
SELECT
  e.learner_id,
  e.school_id,
  e.term
FROM enrollments e
LEFT JOIN attendance a
  ON a.learner_id = e.learner_id
WHERE a.learner_id IS NULL;
