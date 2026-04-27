import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL || 'https://erbidxbhooavcynttbml.supabase.co';
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const userId = process.env.ADMIN_USER_ID || '';
const email = process.env.ADMIN_EMAIL || '';

if (!supabaseUrl || supabaseUrl.includes('YOUR_PROJECT')) {
  throw new Error('Set SUPABASE_URL to your real Supabase project URL');
}

if (!serviceRoleKey || serviceRoleKey.includes('YOUR_SERVICE_ROLE_KEY')) {
  throw new Error('Set SUPABASE_SERVICE_ROLE_KEY to your real service role key');
}

if (!userId && !email) {
  throw new Error('Set ADMIN_USER_ID or ADMIN_EMAIL');
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

async function main() {
  if (userId) {
    const { error } = await supabase.auth.admin.deleteUser(userId, true);
    if (error) throw error;
    console.log(`Soft-deleted user id: ${userId}`);
    return;
  }

  const { data, error } = await supabase.auth.admin.listUsers();
  if (error) throw error;

  const matches = data.users.filter((user) => user.email === email);

  if (matches.length === 0) {
    console.log(`No user found for email: ${email}`);
    return;
  }

  for (const user of matches) {
    const { error: deleteError } = await supabase.auth.admin.deleteUser(user.id, true);
    if (deleteError) throw deleteError;
    console.log(`Soft-deleted user: ${user.email} (${user.id})`);
  }
}

main().catch((error) => {
  console.error(error.message || error);
  process.exit(1);
});
