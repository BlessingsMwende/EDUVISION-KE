-- ===========================================
-- 06_resource_planning.sql
-- Purpose: Predictive Resource Planning (Textbooks & Learning Continuity)
-- Notes: Safe layer (depends only on schools table)
-- ===========================================

-- 1) Resource catalog (textbooks, kits, devices)
CREATE TABLE resources_catalog (
  resource_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  resource_type TEXT NOT NULL,   -- Textbook / LabKit / Device
  subject TEXT,
  grade_level TEXT,
  name TEXT NOT NULL,
  unit_cost NUMERIC(12,2),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 2) School inventory (what each school has)
CREATE TABLE inventory (
  inventory_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id UUID NOT NULL REFERENCES schools(school_id),
  resource_id UUID NOT NULL REFERENCES resources_catalog(resource_id),
  quantity_available INTEGER NOT NULL DEFAULT 0,
  last_updated TIMESTAMP DEFAULT NOW(),
  updated_by UUID REFERENCES users(user_id)  -- nullable if updated by system
);

-- 3) School requests (what schools ask for)
CREATE TABLE resource_requests (
  request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id UUID NOT NULL REFERENCES schools(school_id),
  resource_id UUID NOT NULL REFERENCES resources_catalog(resource_id),
  term TEXT NOT NULL,
  quantity_requested INTEGER NOT NULL,
  status TEXT DEFAULT 'Pending', -- Pending / Approved / Delivered / Rejected
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4) Forecasts (AI/planning outputs)
CREATE TABLE resource_forecasts (
  forecast_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id UUID NOT NULL REFERENCES schools(school_id),
  resource_id UUID NOT NULL REFERENCES resources_catalog(resource_id),
  term TEXT NOT NULL,
  forecast_quantity INTEGER NOT NULL,
  confidence NUMERIC(5,4),
  model_version TEXT,
  drivers_json JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_inventory_school ON inventory(school_id);
CREATE INDEX idx_requests_school_term ON resource_requests(school_id, term);
CREATE INDEX idx_forecasts_school_term ON resource_forecasts(school_id, term);
