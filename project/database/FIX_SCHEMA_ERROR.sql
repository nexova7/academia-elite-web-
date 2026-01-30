-- SCRIPT DE CORRECCIÓN: AGREGAR COLUMNAS FALTANTES
-- Ejecuta este script en el SQL Editor de Supabase para arreglar el error "column rol does not exist".

-- 0. Asegurar Extensiones
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. CORRECCIÓN TABLA ALUMNOS
-- Usamos un bloque DO para agregar las columnas solo si no existen.
DO $$ 
BEGIN 
  -- Columna ROL
  IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'alumnos' AND column_name = 'rol') THEN
    ALTER TABLE public.alumnos ADD COLUMN rol text default 'alumno';
  END IF;

  -- Columna PROGRESO
  IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'alumnos' AND column_name = 'progreso') THEN
    ALTER TABLE public.alumnos ADD COLUMN progreso int default 0;
  END IF;

  -- Columna CLASES_COMPLETADAS
  IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'alumnos' AND column_name = 'clases_completadas') THEN
    ALTER TABLE public.alumnos ADD COLUMN clases_completadas int default 0;
  END IF;

  -- Columna AVATAR_URL
   IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'alumnos' AND column_name = 'avatar_url') THEN
    ALTER TABLE public.alumnos ADD COLUMN avatar_url text;
  END IF;
  
  -- Columna NOMBRE (Por si acaso)
   IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'alumnos' AND column_name = 'nombre') THEN
    ALTER TABLE public.alumnos ADD COLUMN nombre text;
  END IF;
END $$;

-- 2. RECREAR POLÍTICAS DE SEGURIDAD (ALUMNOS)
-- Borramos las viejas para evitar conflictos y las creamos de nuevo
DROP POLICY IF EXISTS "Instructores ven todos los alumnos" ON public.alumnos;
DROP POLICY IF EXISTS "Alumnos pueden ver su propio perfil" ON public.alumnos;
DROP POLICY IF EXISTS "Alumnos pueden actualizar su propio perfil" ON public.alumnos;

ALTER TABLE public.alumnos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Alumnos pueden ver su propio perfil" 
  ON public.alumnos FOR SELECT 
  USING ( auth.uid() = id );

CREATE POLICY "Alumnos pueden actualizar su propio perfil" 
  ON public.alumnos FOR UPDATE 
  USING ( auth.uid() = id );

-- Esta es la política que fallaba antes, ahora funcionará porque ya existe la columna 'rol'
CREATE POLICY "Instructores ven todos los alumnos"
  ON public.alumnos FOR SELECT
  USING ( 
    EXISTS (
      SELECT 1 FROM public.alumnos 
      WHERE id = auth.uid() AND rol = 'instructor'
    ) 
  );

-- 3. TABLA RESERVAS (Verificar existencia y políticas)
CREATE TABLE IF NOT EXISTS public.reservas_clases (
  id uuid default uuid_generate_v4() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  alumno_id uuid references public.alumnos(id) not null,
  instructor text not null, 
  fecha date not null,
  hora text not null,
  notas text,
  estado text default 'CONFIRMADA'
);

ALTER TABLE public.reservas_clases ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Instructores ven todas las reservas" ON public.reservas_clases;
DROP POLICY IF EXISTS "Alumnos ven sus propias reservas" ON public.reservas_clases;
DROP POLICY IF EXISTS "Alumnos pueden crear reservas" ON public.reservas_clases;
DROP POLICY IF EXISTS "Alumnos pueden cancelar (update) sus reservas" ON public.reservas_clases;

CREATE POLICY "Alumnos ven sus propias reservas"
  ON public.reservas_clases FOR SELECT
  USING ( auth.uid() = alumno_id );

CREATE POLICY "Alumnos pueden crear reservas"
  ON public.reservas_clases FOR INSERT
  WITH CHECK ( auth.uid() = alumno_id );

CREATE POLICY "Alumnos pueden cancelar (update) sus reservas"
  ON public.reservas_clases FOR UPDATE
  USING ( auth.uid() = alumno_id );

CREATE POLICY "Instructores ven todas las reservas"
  ON public.reservas_clases FOR SELECT
  USING ( 
     EXISTS (
      SELECT 1 FROM public.alumnos 
      WHERE id = auth.uid() AND rol = 'instructor'
    ) 
  );

-- 4. TABLA NOTAS (Verificar existencia)
CREATE TABLE IF NOT EXISTS public.notas_alumnos (
  id uuid default uuid_generate_v4() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  alumno_id uuid references public.alumnos(id) not null,
  instructor text,
  fecha date default CURRENT_DATE,
  texto text not null
);

ALTER TABLE public.notas_alumnos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Alumnos ven sus propias notas" ON public.notas_alumnos;
DROP POLICY IF EXISTS "Instructores pueden crear notas" ON public.notas_alumnos;

CREATE POLICY "Alumnos ven sus propias notas"
  ON public.notas_alumnos FOR SELECT
  USING ( auth.uid() = alumno_id );

CREATE POLICY "Instructores pueden crear notas"
  ON public.notas_alumnos FOR INSERT
  WITH CHECK ( 
    EXISTS (
      SELECT 1 FROM public.alumnos 
      WHERE id = auth.uid() AND rol = 'instructor'
    ) 
  );

-- ¡SCRIPT DE CORRECCIÓN COMPLETADO!
