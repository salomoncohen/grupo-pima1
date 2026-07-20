create table if not exists pima_config (
  key text primary key,
  value jsonb,
  updated_at timestamptz default now()
);

alter table pima_config enable row level security;

create policy "pima_config_all" on pima_config for all using (true);
