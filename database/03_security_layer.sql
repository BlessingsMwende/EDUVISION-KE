-- 03_security_layer.sql
-- Purpose: Implement Role-Based Access Control (RBAC)
-- and National Audit Logging for accountability.

-- 1) Users
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  org_type TEXT, -- Ministry / County / School
  org_id UUID,
  status TEXT DEFAULT 'Active',
  created_at TIMESTAMP DEFAULT NOW()
);

-- 2) Roles
CREATE TABLE roles (
  role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  role_name TEXT UNIQUE NOT NULL,
  description TEXT
);

-- 3) User-Role Mapping
CREATE TABLE user_roles (
  user_id UUID REFERENCES users(user_id),
  role_id UUID REFERENCES roles(role_id),
  PRIMARY KEY (user_id, role_id)
);

-- 4) Audit Logs
CREATE TABLE audit_logs (
  audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(user_id),
  action TEXT NOT NULL,
  table_name TEXT NOT NULL,
  record_id UUID,
  before_json JSON,
  after_json JSON,
  ip_address TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
