-- ============================================================
-- Run this in Supabase SQL Editor (safe to run multiple times)
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

DROP POLICY IF EXISTS "Public read governorates"  ON public.governorates;
DROP POLICY IF EXISTS "Auth write governorates"   ON public.governorates;
DROP POLICY IF EXISTS "Anon upsert governorates"  ON public.governorates;
DROP POLICY IF EXISTS "Anon update governorates"  ON public.governorates;

CREATE POLICY "Public read governorates"  ON public.governorates FOR SELECT USING (true);
CREATE POLICY "Anon upsert governorates"  ON public.governorates FOR INSERT WITH CHECK (true);
CREATE POLICY "Anon update governorates"  ON public.governorates FOR UPDATE USING (true);

-- 2. Settings table
CREATE TABLE IF NOT EXISTS public.settings (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT ''
);

ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read settings"  ON public.settings;
DROP POLICY IF EXISTS "Anon write settings"   ON public.settings;
DROP POLICY IF EXISTS "Anon insert settings"  ON public.settings;
DROP POLICY IF EXISTS "Anon update settings"  ON public.settings;

CREATE POLICY "Public read settings"  ON public.settings FOR SELECT USING (true);
CREATE POLICY "Anon insert settings"  ON public.settings FOR INSERT WITH CHECK (true);
CREATE POLICY "Anon update settings"  ON public.settings FOR UPDATE USING (true);

-- 3. Seed default wallet_phone if not exists
INSERT INTO public.settings (key, value)
VALUES ('wallet_phone', '')
ON CONFLICT (key) DO NOTHING;

-- 4. Seed Egyptian governorates (default 50 LE shipping)
INSERT INTO public.governorates (name_ar, name_en, shipping_price) VALUES
  ('القاهرة',       'Cairo',          50),
  ('الجيزة',        'Giza',           50),
  ('الإسكندرية',    'Alexandria',     60),
  ('القليوبية',     'Qalyubia',       55),
  ('الشرقية',       'Sharqia',        60),
  ('الغربية',       'Gharbia',        60),
  ('المنوفية',      'Menofia',        60),
  ('الدقهلية',      'Dakahlia',       65),
  ('البحيرة',       'Beheira',        65),
  ('كفر الشيخ',     'Kafr El Sheikh', 65),
  ('دمياط',         'Damietta',       65),
  ('بورسعيد',       'Port Said',      65),
  ('الإسماعيلية',   'Ismailia',       65),
  ('السويس',        'Suez',           65),
  ('الفيوم',        'Faiyum',         70),
  ('بني سويف',      'Beni Suef',      70),
  ('المنيا',        'Minya',          75),
  ('أسيوط',         'Asyut',          75),
  ('سوهاج',         'Sohag',          80),
  ('قنا',           'Qena',           80),
  ('الأقصر',        'Luxor',          85),
  ('أسوان',         'Aswan',          85),
  ('البحر الأحمر',  'Red Sea',        90),
  ('الوادي الجديد', 'New Valley',     90),
  ('مطروح',         'Matruh',         90),
  ('شمال سيناء',    'North Sinai',    90),
  ('جنوب سيناء',    'South Sinai',    90),
  ('السادات',       'Sadat City',     65)
ON CONFLICT (name_en) DO NOTHING;

-- 5. Orders extra columns
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS governorate    TEXT;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS subtotal       NUMERIC(10,2);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS shipping_cost  NUMERIC(10,2);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS proof_url      TEXT;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS payment_method TEXT;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS phone          TEXT;

-- 6. Storage bucket for transfer proofs
INSERT INTO storage.buckets (id, name, public)
VALUES ('proofs', 'proofs', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "Public read proofs"  ON storage.objects;
DROP POLICY IF EXISTS "Anon upload proofs"  ON storage.objects;

CREATE POLICY "Public read proofs"  ON storage.objects FOR SELECT USING (bucket_id = 'proofs');
CREATE POLICY "Anon upload proofs"  ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'proofs');
