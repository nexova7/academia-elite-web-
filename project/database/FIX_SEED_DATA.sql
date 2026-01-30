-- SCRIPT DE CORRECCIÓN: DATOS DE PRUEBA (SEED DATA V2)
-- Este script crea primero el usuario en el sistema de autenticación para evitar el error de llave foránea.

-- 1. Crear el usuario "falso" en la tabla de autenticación de Supabase
-- Esto es necesario porque la tabla 'alumnos' requiere que el ID exista en 'auth.users'.
INSERT INTO auth.users (id, aud, role, email, email_confirmed_at)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'aspirante@elite.com',
  now()
)
ON CONFLICT (id) DO NOTHING;

-- 2. Ahora sí, crear el perfil del alumno
INSERT INTO public.alumnos (id, email, nombre, whatsapp, categoria, clases_completadas, progreso, avatar_url)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'aspirante@elite.com',
  'Aspirante Élite (Demo)',
  '+57 300 123 4567',
  'B1 Particular',
  5, -- 5 clases listas
  45, -- 45% de la licencia
  'https://cdn-icons-png.flaticon.com/512/4140/4140048.png' -- Avatar por defecto
)
ON CONFLICT (id) DO UPDATE SET 
  nombre = EXCLUDED.nombre,
  progreso = EXCLUDED.progreso;

-- 3. Crear una reserva de prueba
INSERT INTO public.reservas_clases (alumno_id, instructor, fecha, hora, estado)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Instructora Liliana',
  CURRENT_DATE + 1, -- Mañana
  '08:00',
  'CONFIRMADA'
);

-- 4. Crear una nota de instructor de prueba
INSERT INTO public.notas_alumnos (alumno_id, instructor, fecha, texto)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Instructor Camilo',
  CURRENT_DATE - 1, -- Ayer
  'Excelente manejo de los espejos. Recuerda suavizar el frenado.'
);
