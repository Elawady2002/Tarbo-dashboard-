-- Create settings table for key-value store
CREATE TABLE IF NOT EXISTS public.settings (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT ''
);

-- Enable Row Level Security
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

-- Allow anon to read settings (e.g. store fetching wallet_phone)
CREATE POLICY "Allow anon read settings"
  ON public.settings
  FOR SELECT
  TO anon
  USING (true);

-- Allow anon to insert/update settings (dashboard uses anon key)
CREATE POLICY "Allow anon upsert settings"
  ON public.settings
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Allow anon update settings"
  ON public.settings
  FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

-- Seed default wallet phone (empty)
INSERT INTO public.settings (key, value)
VALUES ('wallet_phone', '')
ON CONFLICT (key) DO NOTHING;
