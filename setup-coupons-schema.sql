-- Create coupons table
CREATE TABLE IF NOT EXISTS public.coupons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  discount_percentage NUMERIC NOT NULL,
  product_id BIGINT REFERENCES public.products(id) ON DELETE CASCADE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can insert coupons" ON public.coupons;
DROP POLICY IF EXISTS "Anyone can read coupons" ON public.coupons;
DROP POLICY IF EXISTS "Anyone can update coupons" ON public.coupons;
DROP POLICY IF EXISTS "Anyone can delete coupons" ON public.coupons;

CREATE POLICY "Anyone can insert coupons" ON public.coupons FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Anyone can read coupons" ON public.coupons FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Anyone can update coupons" ON public.coupons FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Anyone can delete coupons" ON public.coupons FOR DELETE TO anon, authenticated USING (true);

-- Add discount_percentage to products
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS discount_percentage NUMERIC DEFAULT 0;
