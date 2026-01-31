-- =====================================================
-- MASTER RESET & REPAIR - ACADEMIA ÉLITE
-- =====================================================
-- EJECUTAR ESTO EN SUPABASE SQL EDITOR
-- SOLUCIONA: Error 42P01 (Tablas faltantes: leads, instructores, etc.)
-- =====================================================

-- 1. CREACIÓN ROBUSTA DE TODAS LAS TABLAS BASE
-- Creamos primero las independientes, luego las que tienen referencias.

-- 1.1 INSTRUCTORES (Faltaba esta y causaba el último error)
CREATE TABLE IF NOT EXISTS public.instructores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    especialidad VARCHAR(100),
    foto_url TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_contratacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 1.2 ALUMNOS (Vinculada a auth.users, pero la definimos segura)
CREATE TABLE IF NOT EXISTS public.alumnos (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    whatsapp VARCHAR(20),
    categoria VARCHAR(10) DEFAULT 'B1',
    avatar_url TEXT,
    clases_completadas INT DEFAULT 0,
    puntaje_trivia DECIMAL(5,2) DEFAULT 0,
    progreso DECIMAL(5,2) DEFAULT 0,
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 1.3 SERVICIOS
CREATE TABLE IF NOT EXISTS public.servicios (
    id SERIAL PRIMARY KEY,
    nombre_curso VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(12,2) NOT NULL DEFAULT 0,
    categoria_licencia VARCHAR(10) NOT NULL,
    duracion_horas INT NOT NULL DEFAULT 0,
    nivel_dificultad VARCHAR(20),
    imagen_url TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 1.4 LEADS (Marketing)
CREATE TABLE IF NOT EXISTS public.leads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    origen VARCHAR(50) DEFAULT 'WEB',
    convertido BOOLEAN DEFAULT FALSE,
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 1.5 RESERVAS (Clases)
CREATE TABLE IF NOT EXISTS public.reservas_clases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alumno_id UUID NOT NULL REFERENCES public.alumnos(id) ON DELETE CASCADE,
    instructor VARCHAR(150) NOT NULL, -- Simplificamos para evitar FK circular si instructores falla
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'CONFIRMADA',
    notas TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 1.6 TRIVIA RESULTADOS
CREATE TABLE IF NOT EXISTS public.trivia_resultados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lead_id UUID REFERENCES public.leads(id) ON DELETE SET NULL,
    puntuacion_porcentaje DECIMAL(5,2) NOT NULL DEFAULT 0,
    nivel_alcanzado VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 2. RESET Y APLICACIÓN DE SEGURIDAD (RLS)
-- =====================================================

-- Habilitar RLS en TODO
ALTER TABLE public.instructores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alumnos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.servicios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas_clases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trivia_resultados ENABLE ROW LEVEL SECURITY;

-- Limpiar políticas antiguas para evitar duplicados
DROP POLICY IF EXISTS "Instructores visibles para todos" ON public.instructores;
DROP POLICY IF EXISTS "Public leads insert" ON public.leads;
DROP POLICY IF EXISTS "Public trivia results insert" ON public.trivia_resultados;
DROP POLICY IF EXISTS "Alumnos pueden ver su propio perfil" ON public.alumnos;
DROP POLICY IF EXISTS "Servicios activos son visibles para todos" ON public.servicios;
DROP POLICY IF EXISTS "Servicios visibles para anónimos" ON public.servicios;

-- =====================================================
-- 3. POLÍTICAS DE ACCESO (Definitivas)
-- =====================================================

-- 3.1 Instructores (Ver: Todos)
CREATE POLICY "Instructores visibles para todos"
ON public.instructores FOR SELECT
TO anon, authenticated
USING (activo = TRUE);

-- 3.2 Lead (Crear: Todos - Ver: Nadie)
CREATE POLICY "Public leads insert"
ON public.leads FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- 3.3 Trivia Resultados (Crear: Todos)
CREATE POLICY "Public trivia results insert"
ON public.trivia_resultados FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- 3.4 Alumnos (Ver/Editar: Solo dueño)
CREATE POLICY "Alumnos pueden ver su propio perfil"
ON public.alumnos FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "Alumnos update propio"
ON public.alumnos FOR UPDATE
USING (auth.uid() = id);

CREATE POLICY "Alumnos insert propio"
ON public.alumnos FOR INSERT
WITH CHECK (auth.uid() = id);

-- 3.5 Servicios (Ver: Todos)
CREATE POLICY "Servicios visibles para todos"
ON public.servicios FOR SELECT
TO anon, authenticated
USING (activo = TRUE);

-- =====================================================
-- 4. DATOS SEMILLA BÁSICOS (Para que la app no se vea vacía)
-- =====================================================

-- Insertar instructores si está vacío
INSERT INTO public.instructores (nombre, email, especialidad)
SELECT 'Instructor Camilo', 'camilo@elite.com', 'Manejo Defensivo'
WHERE NOT EXISTS (SELECT 1 FROM public.instructores WHERE email = 'camilo@elite.com');

INSERT INTO public.instructores (nombre, email, especialidad)
SELECT 'Instructora Liliana', 'liliana@elite.com', 'Seguridad Vial'
WHERE NOT EXISTS (SELECT 1 FROM public.instructores WHERE email = 'liliana@elite.com');

