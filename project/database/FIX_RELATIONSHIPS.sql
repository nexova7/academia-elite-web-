-- ========================================================
-- REPARACIÓN DEFINITIVA DE RELACIONES (FOREIGN KEYS)
-- ========================================================
-- Este script fuerza la creación del enlace entre 'reservas_clases' y 'alumnos'.
-- Si Supabase no detecta la relación, este script la reconstruye.

-- 1. Intentar eliminar cualquier restricción antigua mal formada
ALTER TABLE public.reservas_clases 
DROP CONSTRAINT IF EXISTS "reservas_clases_alumno_id_fkey";

ALTER TABLE public.reservas_clases 
DROP CONSTRAINT IF EXISTS "fk_reservas_alumnos";

-- 2. Asegurar que la columna 'alumno_id' existe y tiene el tipo correcto
-- (Si ya existe, esto no hará nada dañino, solo asegura)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reservas_clases' AND column_name='alumno_id') THEN
        ALTER TABLE public.reservas_clases ADD COLUMN alumno_id UUID;
    END IF;
END $$;

-- 3. CREAR LA RELACIÓN (FOREIGN KEY) EXPLÍCITA
-- Esto es lo que Supabase busca para permitir: select(..., alumnos(...))
ALTER TABLE public.reservas_clases
ADD CONSTRAINT fk_reservas_alumnos
FOREIGN KEY (alumno_id)
REFERENCES public.alumnos(id)
ON DELETE CASCADE;

-- 4. ACTUALIZAR CACHÉ DEL ESQUEMA
-- Al comentar la tabla, forzamos a Supabase a refrescar su estructura interna
COMMENT ON TABLE public.reservas_clases IS 'Tabla de reservas con relación reparada a alumnos';

-- 5. VERIFICACIÓN DE PERMISOS (Por si acaso se perdieron)
GRANT SELECT, INSERT, UPDATE, DELETE ON public.reservas_clases TO anon, authenticated, service_role;
GRANT SELECT ON public.alumnos TO anon, authenticated, service_role;
