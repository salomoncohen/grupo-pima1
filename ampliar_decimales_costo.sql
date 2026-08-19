-- Ampliar las columnas de costo/precio a 4 decimales (antes solo guardaban 2)
-- Esto NO borra ni redondea los datos existentes, solo permite que a partir de ahora
-- se guarden hasta 4 decimales sin recortarlos.

alter table pima_products
  alter column costo type numeric(14,4);

alter table pima_price_history
  alter column precio_anterior type numeric(14,4),
  alter column precio_nuevo type numeric(14,4);
