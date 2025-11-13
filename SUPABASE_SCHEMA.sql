-- Smart Trash Bin Monitoring System - Complete Schema
-- Copy dan paste ke SQL Editor di Supabase Dashboard

-- Create users table for authentication
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  phone TEXT,
  role TEXT NOT NULL DEFAULT 'public' CHECK (role IN ('public', 'officer', 'admin')),
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create trash_bins table with extended fields
CREATE TABLE IF NOT EXISTS trash_bins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  location TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  fill_level INTEGER NOT NULL DEFAULT 0 CHECK (fill_level >= 0 AND fill_level <= 100),
  status TEXT NOT NULL DEFAULT 'normal' CHECK (status IN ('normal', 'warning', 'full')),
  sensor_id TEXT,
  battery_level INTEGER CHECK (battery_level >= 0 AND battery_level <= 100),
  capacity INTEGER,
  images JSONB DEFAULT '[]'::jsonb,
  notes TEXT,
  last_collection TIMESTAMP WITH TIME ZONE,
  next_collection TIMESTAMP WITH TIME ZONE,
  field_officer_id UUID REFERENCES users(id) ON DELETE SET NULL,
  last_updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bin_id UUID NOT NULL REFERENCES trash_bins(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'info' CHECK (type IN ('info', 'warning', 'critical')),
  read BOOLEAN NOT NULL DEFAULT FALSE,
  acknowledged_by UUID REFERENCES users(id) ON DELETE SET NULL,
  acknowledged_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_trash_bins_status ON trash_bins(status);
CREATE INDEX IF NOT EXISTS idx_trash_bins_location ON trash_bins(location);
CREATE INDEX IF NOT EXISTS idx_trash_bins_field_officer ON trash_bins(field_officer_id);
CREATE INDEX IF NOT EXISTS idx_trash_bins_last_updated ON trash_bins(last_updated DESC);
CREATE INDEX IF NOT EXISTS idx_trash_bins_coords ON trash_bins(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_notifications_bin_id ON notifications(bin_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

-- Enable RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE trash_bins ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users table
CREATE POLICY "users_select_own" ON users FOR SELECT USING (true);
CREATE POLICY "users_insert_auth" ON users FOR INSERT WITH CHECK (true);
CREATE POLICY "users_update_own" ON users FOR UPDATE USING (true) WITH CHECK (true);

-- RLS Policies for trash_bins table
CREATE POLICY "trash_bins_select_all" ON trash_bins FOR SELECT USING (true);
CREATE POLICY "trash_bins_insert_auth" ON trash_bins FOR INSERT WITH CHECK (true);
CREATE POLICY "trash_bins_update_auth" ON trash_bins FOR UPDATE USING (true) WITH CHECK (true);

-- RLS Policies for notifications table
CREATE POLICY "notifications_select_all" ON notifications FOR SELECT USING (true);
CREATE POLICY "notifications_insert_auth" ON notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "notifications_update_auth" ON notifications FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "notifications_delete_auth" ON notifications FOR DELETE USING (true);

-- Sample data for testing
INSERT INTO users (id, name, email, password_hash, phone, role) VALUES
  ('550e8400-e29b-41d4-a716-446655440100', 'Admin User', 'admin@example.com', 'hashed_password_here', '+62812345678', 'admin'),
  ('550e8400-e29b-41d4-a716-446655440101', 'Officer Ahmad', 'ahmad@example.com', 'hashed_password_here', '+62812345679', 'officer'),
  ('550e8400-e29b-41d4-a716-446655440102', 'Budi Santoso', 'budi@example.com', 'hashed_password_here', '+62812345680', 'public')
ON CONFLICT (id) DO NOTHING;

INSERT INTO trash_bins (id, name, location, latitude, longitude, fill_level, status, sensor_id, battery_level, capacity, field_officer_id, notes) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'Eco Bin A', 'Jalan Sudirman No. 45', -6.2250, 106.8000, 35, 'normal', 'sensor-001', 92, 120, '550e8400-e29b-41d4-a716-446655440101', 'Near bank ATM'),
  ('550e8400-e29b-41d4-a716-446655440002', 'Eco Bin B', 'Plaza Senayan', -6.2170, 106.7980, 72, 'warning', 'sensor-002', 78, 120, '550e8400-e29b-41d4-a716-446655440101', 'Main entrance'),
  ('550e8400-e29b-41d4-a716-446655440003', 'Eco Bin C', 'Taman Suropati', -6.1900, 106.8250, 88, 'full', 'sensor-003', 55, 100, '550e8400-e29b-41d4-a716-446655440101', 'Needs immediate collection'),
  ('550e8400-e29b-41d4-a716-446655440004', 'Eco Bin D', 'Menteng Plaza', -6.1850, 106.8300, 45, 'normal', 'sensor-004', 88, 150, '550e8400-e29b-41d4-a716-446655440101', 'Side parking'),
  ('550e8400-e29b-41d4-a716-446655440005', 'Eco Bin E', 'Blok M Square', -6.2600, 106.8100, 62, 'warning', 'sensor-005', 65, 120, '550e8400-e29b-41d4-a716-446655440101', 'Near cafe')
ON CONFLICT (id) DO NOTHING;

-- NOTES FOR SETUP:
-- 1. Go to Supabase Dashboard > SQL Editor
-- 2. Copy and paste all SQL above
-- 3. Run the script
-- 4. Sample data will be inserted (you can use for testing)
-- 5. IMPORTANT: Update password hashes in users table with actual bcrypt hashes
--    To generate: npm run hash-password "your_password"
-- 6. Get your SUPABASE_URL and SUPABASE_ANON_KEY from Settings > API
-- 7. Add them to .env files
