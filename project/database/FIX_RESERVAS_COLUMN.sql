-- SCRIPT DE CORRECCIÓN FINAL: COLUMNA ESTADO FALTANTE
-- Este script arregla el error "column estado does not exist" en la tabla reservas_clases.

DO $$ 
BEGIN 
  -- Agregar columna ESTADO si no existe
  IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'reservas_clases' AND column_name = 'estado') THEN
    ALTER TABLE public.reservas_clases ADD COLUMN estado text default 'CONFIRMADA';
  END IF;

  -- Agregar restricción de valores válidos (Check constraint)
  -- Primero intentamos eliminarla por si acaso existe con otro nombre o configuración
  BEGIN
    ALTER TABLE public.reservas_clases DROP CONSTRAINT IF EXISTS valid_estado;
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;
  
  ALTER TABLE public.reservas_clases ADD CONSTRAINT valid_estado CHECK (estado IN ('CONFIRMADA', 'CANCELADA', 'COMPLETADA'));

END $$;

-- Volver a intentar la inserción de datos de prueba (SEED DATA)
-- (Esta parte es opcional si prefieres correr el script SEED original de nuevo, pero la incluyo para facilitar)

INSERT INTO public.reservas_clases (alumno_id, instructor, fecha, hora, estado)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'Instructora Liliana',
  CURRENT_DATE + 1,
  '08:00',
  'CONFIRMADA'
);
