-- SCRIPT DE CORRECCIÓN: AGREGAR COLUMNA 'NOTAS'
-- Este script soluciona el error: "Could not find the 'notas' column of 'reservas_clases' in the schema cache"
-- Ejecutar en: Supabase SQL Editor

-- 1. Agregar la columna 'notas' si no existe
ALTER TABLE public.reservas_clases 
ADD COLUMN IF NOT EXISTS notas TEXT;

-- 2. Asegurar que el propietario (PostgREST) vea los cambios
-- (Esto suele ser automático, pero un comentario 'notify' ayuda a veces)
COMMENT ON COLUMN public.reservas_clases.notas IS 'Notas opcionales del alumno para la clase';

-- 3. Confirmación
SELECT 'COLUMNA NOTAS AGREGADA EXITOSAMENTE' as status;
