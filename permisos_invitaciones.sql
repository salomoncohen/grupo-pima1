-- Permite invitar usuarios por correo y que ellos mismos pongan su contraseña
alter table pima_users add column if not exists invite_token text;
alter table pima_users add column if not exists invite_status text default 'active';
alter table pima_users add column if not exists email text;
alter table pima_users alter column password_hash drop not null;

-- Permisos granulares por usuario (además del rol admin/usuario)
alter table pima_users add column if not exists permisos jsonb default '{}'::jsonb;
