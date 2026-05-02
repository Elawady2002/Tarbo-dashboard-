-- ============================================================
-- Run this in Supabase SQL Editor
-- ============================================================

-- 1. Governorates table
CREATE TABLE IF NOT EXISTS public.governorates (
  id            BIGSERIAL PRIMARY KEY,
  name_ar       TEXT NOT NULL,
  name_en       TEXT NOT NULL UNIQUE,
  shipping_price NUMERIC(10,2) NOT NULL DEFAULT 50,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.governorates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read governorates" ON public.governorates FOR SELECT USING (true);
CREATE POLICY "Auth write governorates"  ON public.governorates FOR ALL USING (auth.role() = 'authenticated');
-- Allow anon to upsert (for auto-seeding from dashboard)
CREATE POLICY "Anon upsert governorates" ON public.governorates FOR INSERT WITH CHECK (true);
CREATE POLICY "Anon update governorates" ON public.governorates FOR UPDATE USING (true);

-- 2. Settings table (key/value store)
CREATE TABLE IF NOT EXISTS public.settings (
  key   TEXT PRIMARY KEY,
  value TEXT
);

ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read settings" ON public.settings FOR SELECT USING (true);
CREATE POLICY "Anon write settings"  ON public.settings FOR ALL USING (true);

-- 3. Add new columns to orders table (if not already there)
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS governorate    TEXT;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS subtotal       NUMERIC(10,2);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS shipping_cost  NUMERIC(10,2);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS proof_url      TEXT;

-- 4. Storage bucket for transfer proofs (run once)
-- Go to Storage in Supabase dashboard and create a bucket named "proofs" (public)
-- OR run:
INSERT INTO storage.buckets (id, name, public)
VALUES ('proofs', 'proofs', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Public read proofs" ON storage.objects FOR SELECT USING (bucket_id = 'proofs');
CREATE POLICY "Anon upload proofs" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'proofs');
