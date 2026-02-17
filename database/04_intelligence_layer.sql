-- ===========================================
-- STEP 4: INTELLIGENCE & ANALYTICS LAYER
-- Purpose: Store AI predictions and national insights
-- ===========================================

-- Ensure UUID generator works
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1) Learner Predictions
CREATE TABLE IF NOT EXISTS learner_predictions (
    prediction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    learner_id UUID NOT NULL REFERENCES learners(learner_id),
    term TEXT NOT NULL,
    predicted_score NUMERIC(5,2),
    performance_band TEXT, -- Below / Meeting / Exceeding Expectation
    confidence_score NUMERIC(5,2),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2) STEM Score Intelligence
CREATE TABLE IF NOT EXISTS stem_scores (
    stem_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    learner_id UUID NOT NULL REFERENCES learners(learner_id),
    term TEXT NOT NULL,
    math_score NUMERIC(5,2),
    science_score NUMERIC(5,2),
    technology_score NUMERIC(5,2),
    engineering_score NUMERIC(5,2),
    stem_average NUMERIC(5,2),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 3) Risk Signals (Dropout / Low Performance / Ghost Patterns)
CREATE TABLE IF NOT EXISTS risk_signals (
    risk_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    learner_id UUID NOT NULL REFERENCES learners(learner_id),
    term TEXT NOT NULL,
    risk_type TEXT, -- Dropout / Chronic Absence / Low Performance
    risk_score NUMERIC(5,2),
    severity_level INTEGER, -- 1 to 5
    status TEXT DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT NOW()
);

-- 4) National Analytics Summary
CREATE TABLE IF NOT EXISTS national_analytics_summary (
    summary_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    county_id UUID REFERENCES counties(county_id),
    term TEXT NOT NULL,
    average_score NUMERIC(5,2),
    stem_index NUMERIC(5,2),
    dropout_risk_percentage NUMERIC(5,2),
    ghost_learner_flags INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Performance Indexes
CREATE INDEX IF NOT EXISTS idx_predictions_learner_term
ON learner_predictions(learner_id, term);

CREATE INDEX IF NOT EXISTS idx_stem_learner_term
ON stem_scores(learner_id, term);

CREATE INDEX IF NOT EXISTS idx_risk_learner_term
ON risk_signals(learner_id, term);

CREATE INDEX IF NOT EXISTS idx_national_county_term
ON national_analytics_summary(county_id, term);

