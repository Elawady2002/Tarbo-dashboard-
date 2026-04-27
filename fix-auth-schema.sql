-- This table is owned by Supabase Auth, so direct ALTER/UPDATE statements from the
-- SQL editor can fail with "must be owner of table users".
-- Use the Supabase Dashboard instead:
-- Authentication > Users > create/recreate the admin user, or inspect the row there.

select id, email, confirmation_token, email_change, email_change_token_new, recovery_token
from auth.users
where email = 'admin@tarbo.store';
