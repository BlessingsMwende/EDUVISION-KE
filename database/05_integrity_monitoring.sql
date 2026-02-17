-- ===========================================
-- 05_integrity_monitoring.sql
-- Purpose: Data Integrity & Anomaly Monitoring (Safe Option A)
-- Notes: Ghost-learner view is commented out to avoid dependency errors.
-- ===========================================

-- Integrity flags table (generic for learners/schools/enrollments/assessments)
CREATE TABLE integrity_flags (
    flag_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    entity_type TEXT NOT NULL,     -- Learner / School / Enrollment / Assessment
    entity_id UUID NOT NULL,       -- ID of the entity being flagged

    flag_type TEXT NOT NULL,       -- Duplicate / Ghost / Suspicious Pattern
    severity_level INTEGER NOT NULL DEFAULT 1,  -- 1 (low) to 5 (critical)

    description TEXT,
    evidence JSONB,
    status TEXT DEFAULT 'Open',    -- Open / Investigating / Resolved / False Positive

    created_at TIMESTAMP DEFAULT NOW(),
    resolved_at TIMESTAMP
);

-- Indexes
CREATE INDEX idx_integrity_entity ON integrity_flags(entity_type, entity_id);
CREATE INDEX idx_integrity_status ON integrity_flags(status);
CREATE INDEX idx_integrity_severity ON integrity_flags(severity_level);

-- SAFE support view: possible duplicate learners (depends only on learners table)
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

-- FUTURE (enable later after attendance exists)
-- CREATE OR REPLACE VIEW v_potential_ghost_learners AS
-- SELECT e.learner_id, e.school_id, e.term
-- FROM enrollments e
-- LEFT JOIN attendance a ON a.learner_id = e.learner_id
-- WHERE a.learner_id IS NULL;
