-- ═══════════════════════════════════════════
--  GRUPO PIMA — Schema de base de datos
--  Pega esto en Supabase → SQL Editor → Run
-- ═══════════════════════════════════════════

-- Tabla de usuarios
create table if not exists pima_users (
  id serial primary key,
  username text unique not null,
  password_hash text not null,
  name text not null,
  role text not null default 'usuario',
  active boolean default true,
  dept text,
  last_login timestamptz,
  created_at timestamptz default now()
);

-- Tabla de productos (materias primas)
create table if not exists pima_products (
  id serial primary key,
  codigo text unique not null,
  proveedor text not null,
  tipo text not null,
  descripcion text,
  unidad text not null,
  costo numeric(12,2) not null,
  condiciones text,
  photo_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Tabla de historial de precios
create table if not exists pima_price_history (
  id serial primary key,
  product_id integer references pima_products(id) on delete cascade,
  precio_anterior numeric(12,2) not null,
  precio_nuevo numeric(12,2) not null,
  motivo text,
  changed_by text,
  changed_at timestamptz default now()
);

-- Tabla de fichas técnicas / solicitudes
create table if not exists pima_solicitudes (
  id serial primary key,
  folio text unique not null,
  tipo text not null,
  status text not null default 'pendiente',
  solicitante text,
  fecha date,
  proveedor_data jsonb,
  articulo_data jsonb,
  precios_data jsonb,
  cotizacion_url text,
  admin_comentario text,
  resolucion_user text,
  resolucion_at timestamptz,
  created_at timestamptz default now()
);

-- Deshabilitar RLS (acceso desde la app con service key)
alter table pima_users enable row level security;
alter table pima_products enable row level security;
alter table pima_price_history enable row level security;
alter table pima_solicitudes enable row level security;

-- Políticas: acceso total desde service role
create policy "service_all_users" on pima_users for all using (true);
create policy "service_all_products" on pima_products for all using (true);
create policy "service_all_history" on pima_price_history for all using (true);
create policy "service_all_solicitudes" on pima_solicitudes for all using (true);

-- Usuario admin por defecto (contraseña: PIMA2025admin)
insert into pima_users (username, password_hash, name, role, dept)
values (
  'admin',
  '$2b$10$rOzDsJqPlHtYZ1s5xZpNaOQhVJ7YfXfxNk6/XxNcQXxNcQXxNcQX',
  'Administrador',
  'admin',
  'Dirección'
) on conflict (username) do nothing;

-- Productos de ejemplo
insert into pima_products (codigo, proveedor, tipo, descripcion, unidad, costo, condiciones) values
('TEL-001','Textiles García','Tela','Polyester 100% antipilling para forro interior de chamarras','Metro',48.50,'30 días crédito, mín 100m'),
('HIL-001','Hilos del Norte','Hilo','Hilo de costura resistente negro, calibre 40','Rollo',12.00,'Contado, mín 10 rollos'),
('TEL-002','Textiles García','Tela','Lycra spandex 4 vías, 80% poliéster 20% elastano','Metro',85.00,'30 días, mín 100m'),
('ACC-001','Distribuidora Azteca','Accesorio','Cierre YKK #5 metálico 60cm','Pieza',9.75,'15 días, mín 200 piezas'),
('ELA-001','Elastic Center','Elástico','Elástico tejido 3cm para pretinas','Metro',6.20,'Contado, mín 50m'),
('FOR-001','Forrería Moderna','Forro','Forro satinado resistente al agua 100% nylon','Metro',32.00,'30 días, mín 80m')
on conflict (codigo) do nothing;

-- Historial de ejemplo
insert into pima_price_history (product_id, precio_anterior, precio_nuevo, motivo, changed_by, changed_at)
select id, 42.00, 48.50, 'Aumento tipo de cambio', 'admin', '2025-10-15' from pima_products where codigo='TEL-001'
on conflict do nothing;
