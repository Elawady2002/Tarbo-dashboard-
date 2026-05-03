-- Run this in Supabase SQL Editor to ensure orders table is correctly set up with RLS policies.

CREATE TABLE IF NOT EXISTS public.orders (
  id BIGSERIAL PRIMARY KEY,
  customer_name TEXT,
  phone TEXT,
  address TEXT,
  governorate TEXT,
  payment_method TEXT,
  proof_url TEXT,
  items JSONB,
  subtotal NUMERIC(10,2),
  shipping_cost NUMERIC(10,2),
  total_price NUMERIC(10,2),
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "Anyone can insert orders" ON public.orders;
DROP POLICY IF EXISTS "Anyone can read orders" ON public.orders;

-- Create policies (using anon for both store and dashboard)
CREATE POLICY "Anyone can insert orders" 
ON public.orders FOR INSERT 
TO anon, authenticated
WITH CHECK (true);

CREATE POLICY "Anyone can read orders" 
ON public.orders FOR SELECT 
TO anon, authenticated
USING (true);

CREATE POLICY "Anyone can update orders" 
ON public.orders FOR UPDATE 
TO anon, authenticated
USING (true)
WITH CHECK (true);

-- Ensure proofs bucket exists and has correct policies
INSERT INTO storage.buckets (id, name, public)
VALUES ('proofs', 'proofs', true)
ON CONFLICT (id) DO UPDATE SET public = true;

DROP POLICY IF EXISTS "Public read proofs" ON storage.objects;
DROP POLICY IF EXISTS "Public upload proofs" ON storage.objects;

CREATE POLICY "Public read proofs"
ON storage.objects FOR SELECT
TO anon, authenticated
USING (bucket_id = 'proofs');

CREATE POLICY "Public upload proofs"
ON storage.objects FOR INSERT
TO anon, authenticated
WITH CHECK (bucket_id = 'proofs');
