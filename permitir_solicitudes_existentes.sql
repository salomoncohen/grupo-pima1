-- Este nuevo permiso "crear_solicitudes" es requerido para poder usar "Nueva solicitud".
-- Corre esto para que los usuarios de Consulta que ya tenías sigan pudiendo crear solicitudes
-- (si no lo corres, tendrás que activarles la casilla manualmente uno por uno en Usuarios).

update pima_users
set permisos = coalesce(permisos, '{}'::jsonb) || '{"crear_solicitudes": true}'::jsonb
where role = 'usuario';
