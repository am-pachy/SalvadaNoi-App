import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://zjqgwkttdnvkfxnjumzg.supabase.co';
const supabaseAnonKey = 'REPLACE_WITH_YOUR_SUPABASE_ANON_KEY';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
