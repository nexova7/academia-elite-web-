-- SCRIPT DEFINITIVO DE REPARACIÓN (FINAL_DB_FIX.sql)
-- Ejecuta este script para forzar la creación de la columna y los datos.

-- 1. Forzar creación de la columna 'estado' (si no existe, la crea; si existe, no hace nada)
ALTER TABLE public.reservas_clases 
ADD COLUMN IF NOT EXISTS estado text DEFAULT 'CONFIRMADA';

-- 2. Asegurar que la restricción de validación esté correcta
ALTER TABLE public.reservas_clases DROP CONSTRAINT IF EXISTS valid_estado;
ALTER TABLE public.reservas_clases ADD CONSTRAINT valid_estado CHECK (estado IN ('CONFIRMADA', 'CANCELADA', 'COMPLETADA'));

-- 3. Crear el Usuario de Autenticación (para evitar error de llave foránea)
INSERT INTO auth.users (id, aud, role, email, email_confirmed_at)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'aspirante@elite.com',
  now()
)
ON CONFLICT (id) DO NOTHING;

-- 4. Insertar Perfil del Alumno
INSERT INTO public.alumnos (id, email, nombre, whatsapp, categoria, clases_completadas, progreso, avatar_url)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'aspirante@elite.com',
  'Aspirante Élite (Demo)',
  '+57 300 123 4567',
  'B1 Particular',
  5,
  45,
  'https://cdn-icons-png.flaticon.com/512/4140/4140048.png'
)
ON CONFLICT (id) DO UPDATE SET 
  nombre = EXCLUDED.nombre,
  progreso = EXCLUDED.progreso;

-- 5. Insertar Reserva de Prueba
INSERT INTO public.reservas_clases (alumno_id, instructor, fecha, hora, estado)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Instructora Liliana',
  CURRENT_DATE + 1, -- Mañana
  '08:00',
  'CONFIRMADA'
);

-- 6. Insertar Nota de Prueba
INSERT INTO public.notas_alumnos (alumno_id, instructor, fecha, texto)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Instructor Camilo',
  CURRENT_DATE - 1, -- Ayer
  'Excelente manejo de los espejos. Recuerda suavizar el frenado.'
);
