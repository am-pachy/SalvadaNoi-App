create table if not exists user_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text,
  partner_name text,
  savings_goal numeric,
  goal_date date,
  gender text,
  custom_categories text[] default '{}',
  fixed_expenses_setup boolean default false,
  created_at timestamp with time zone default now()
);

alter table user_profiles enable row level security;
drop policy if exists "Users can view own profile" on user_profiles;
drop policy if exists "Users can insert own profile" on user_profiles;
drop policy if exists "Users can update own profile" on user_profiles;
create policy "Users can view own profile" on user_profiles for select using (auth.uid() = id);
create policy "Users can insert own profile" on user_profiles for insert with check (auth.uid() = id);
create policy "Users can update own profile" on user_profiles for update using (auth.uid() = id);

create table if not exists movements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  description text not null,
  amount numeric not null,
  type text check (type in ('entrata','uscita')) not null,
  nature text check (nature in ('fissa','una_tantum')),
  recurrence_frequency text check (recurrence_frequency in ('giornaliera','settimanale','mensile','trimestrale','semestrale','annuale')),
  category text,
  created_at timestamp with time zone default now(),
  linked_debt_id uuid,
  is_auto_generated boolean default false
);

alter table movements enable row level security;
drop policy if exists "Users can view own movements" on movements;
drop policy if exists "Users can insert own movements" on movements;
drop policy if exists "Users can update own movements" on movements;
drop policy if exists "Users can delete own movements" on movements;
create policy "Users can view own movements" on movements for select using (auth.uid() = user_id);
create policy "Users can insert own movements" on movements for insert with check (auth.uid() = user_id);
create policy "Users can update own movements" on movements for update using (auth.uid() = user_id);
create policy "Users can delete own movements" on movements for delete using (auth.uid() = user_id);

create table if not exists debts_credits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  person_name text not null,
  reason text,
  amount numeric not null,
  type text check (type in ('ricevere','dare')) not null,
  status text check (status in ('pendenza','saldato')) default 'pendenza',
  due_date date,
  paid_at timestamp with time zone,
  created_at timestamp with time zone default now()
);

alter table debts_credits enable row level security;
drop policy if exists "Users can view own debts" on debts_credits;
drop policy if exists "Users can insert own debts" on debts_credits;
drop policy if exists "Users can update own debts" on debts_credits;
drop policy if exists "Users can delete own debts" on debts_credits;
create policy "Users can view own debts" on debts_credits for select using (auth.uid() = user_id);
create policy "Users can insert own debts" on debts_credits for insert with check (auth.uid() = user_id);
create policy "Users can update own debts" on debts_credits for update using (auth.uid() = user_id);
create policy "Users can delete own debts" on debts_credits for delete using (auth.uid() = user_id);

create table if not exists goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  name text not null,
  target_amount numeric not null,
  current_amount numeric default 0,
  deadline date,
  created_at timestamp with time zone default now()
);

alter table goals enable row level security;
drop policy if exists "Users can view own goals" on goals;
drop policy if exists "Users can insert own goals" on goals;
drop policy if exists "Users can update own goals" on goals;
drop policy if exists "Users can delete own goals" on goals;
create policy "Users can view own goals" on goals for select using (auth.uid() = user_id);
create policy "Users can insert own goals" on goals for insert with check (auth.uid() = user_id);
create policy "Users can update own goals" on goals for update using (auth.uid() = user_id);
create policy "Users can delete own goals" on goals for delete using (auth.uid() = user_id);

create table if not exists budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  month_ref date not null,
  category text not null,
  limit_amount numeric not null,
  created_at timestamp with time zone default now(),
  unique(user_id, month_ref, category)
);

alter table budgets enable row level security;
drop policy if exists "Users can view own budgets" on budgets;
drop policy if exists "Users can insert own budgets" on budgets;
drop policy if exists "Users can update own budgets" on budgets;
drop policy if exists "Users can delete own budgets" on budgets;
create policy "Users can view own budgets" on budgets for select using (auth.uid() = user_id);
create policy "Users can insert own budgets" on budgets for insert with check (auth.uid() = user_id);
create policy "Users can update own budgets" on budgets for update using (auth.uid() = user_id);
create policy "Users can delete own budgets" on budgets for delete using (auth.uid() = user_id);
