-- QUICK FIX: Create/Update users table with required columns
-- If the users table already exists without the 'name' column, 
-- run this to add the missing column

-- Option 1: If users table doesn't exist, create it
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

-- Option 2: If users table exists but is missing columns, add them
-- (These commands will fail silently if columns already exist)
ALTER TABLE users ADD COLUMN IF NOT EXISTS name TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'public';
ALTER TABLE users ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login TIMESTAMP WITH TIME ZONE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE;

-- Option 3: If users table exists and has wrong structure, delete and recreate
-- WARNING: This will delete all data!
-- DROP TABLE IF EXISTS users CASCADE;
-- Then run the CREATE TABLE statement from Option 1

-- Create trash_bins table (needed for bin management)
CREATE TABLE IF NOT EXISTS trash_bins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  location TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  fill_level INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'normal',
  sensor_id TEXT,
  battery_level INTEGER,
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

-- Create notifications table (needed for alerts)
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bin_id UUID NOT NULL REFERENCES trash_bins(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'info',
  read BOOLEAN NOT NULL DEFAULT FALSE,
  acknowledged_by UUID REFERENCES users(id) ON DELETE SET NULL,
  acknowledged_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_trash_bins_location ON trash_bins(location);
CREATE INDEX IF NOT EXISTS idx_trash_bins_status ON trash_bins(status);
CREATE INDEX IF NOT EXISTS idx_notifications_bin_id ON notifications(bin_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(read);

-- Enable RLS (Row Level Security) - Optional but recommended
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE trash_bins ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
