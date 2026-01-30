-- SCRIPT DE DATOS DE PRUEBA (SEED DATA)
-- Ejecuta esto para ver datos falsos en el Dashboard sin necesidad de registrarte.

-- 1. Crear el usuario de prueba (corresponde al ID que usa el código cuando no hay sesión)
INSERT INTO public.alumnos (id, email, nombre, whatsapp, categoria, clases_completadas, progreso, avatar_url)
VALUES (
  '00000000-0000-0000-0000-000000000000', -- ID Especial de Prueba
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

-- 2. Crear una reserva de prueba
INSERT INTO public.reservas_clases (alumno_id, instructor, fecha, hora, estado)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Instructora Liliana',
  CURRENT_DATE + 1, -- Mañana
  '08:00',
  'CONFIRMADA'
);

-- 3. Crear una nota de instructor de prueba
INSERT INTO public.notas_alumnos (alumno_id, instructor, fecha, texto)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Instructor Camilo',
  CURRENT_DATE - 1, -- Ayer
  'Excelente manejo de los espejos. Recuerda suavizar el frenado.'
);
