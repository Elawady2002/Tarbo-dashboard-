import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL || 'https://erbidxbhooavcynttbml.supabase.co';
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const userId = process.env.ADMIN_USER_ID || '';
const email = process.env.ADMIN_EMAIL || 'admin@tarbo.store';
const password = process.env.ADMIN_PASSWORD || 'admin123456';

if (!supabaseUrl || supabaseUrl.includes('YOUR_PROJECT')) {
  throw new Error('Set SUPABASE_URL to your real Supabase project URL');
}

if (!serviceRoleKey || serviceRoleKey.includes('YOUR_SERVICE_ROLE_KEY')) {
  throw new Error('Set SUPABASE_SERVICE_ROLE_KEY to your real service role key');
}

if (!password) {
  throw new Error('Missing ADMIN_PASSWORD');
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

async function main() {
  if (userId) {
    const { error: deleteError } = await supabase.auth.admin.deleteUser(userId);
    if (deleteError) throw deleteError;
    console.log(`Deleted user id: ${userId}`);
  } else {
    const { data, error } = await supabase.auth.admin.listUsers();
    if (error) throw error;

    const matches = data.users.filter((user) => user.email === email);

    for (const user of matches) {
      const { error: deleteError } = await supabase.auth.admin.deleteUser(user.id);
      if (deleteError) throw deleteError;
      console.log(`Deleted user: ${user.email} (${user.id})`);
    }
  }

  const { data: created, error: createError } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (createError) throw createError;

  console.log(`Created user: ${created.user.email} (${created.user.id})`);
}

main().catch((error) => {
  console.error(error.message || error);
  process.exit(1);
});
