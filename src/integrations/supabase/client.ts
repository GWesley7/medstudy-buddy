import { createClient } from "@supabase/supabase-js";
import { validateSupabaseEnv } from "@/integrations/supabase/env";

const supabaseEnv = validateSupabaseEnv(import.meta.env, {
  mode: import.meta.env.MODE,
});

export const supabase = createClient(
  supabaseEnv.VITE_SUPABASE_URL,
  supabaseEnv.VITE_SUPABASE_PUBLISHABLE_KEY,
  {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
    },
  },
);

export type SupabaseClient = typeof supabase;
