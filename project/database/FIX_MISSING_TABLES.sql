-- =====================================================
-- SCRIPT DE REPARACIÓN Y SEGURIDAD - ACADEMIA ÉLITE
-- =====================================================

-- OBJETIVO: Crear tablas faltantes (leads) y aplicar seguridad en un solo paso.
-- Ejecutar en: Supabase SQL Editor

-- 1. CREAR TABLAS FALTANTES (Si no existen)

-- 1.1 Tabla LEADS (Causa del error 42P01)
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

-- 1.2 Tabla TRIVIA_RESULTADOS (Depende de leads)
CREATE TABLE IF NOT EXISTS public.trivia_resultados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lead_id UUID REFERENCES public.leads(id) ON DELETE SET NULL,
    puntuacion_porcentaje DECIMAL(5,2) NOT NULL CHECK (puntuacion_porcentaje >= 0 AND puntuacion_porcentaje <= 100),
    nivel_alcanzado VARCHAR(50),
    respuestas_correctas INT,
    total_preguntas INT,
    tiempo_segundos INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 1.3 Crear Índices para optimización
CREATE INDEX IF NOT EXISTS idx_leads_email ON public.leads(email);
CREATE INDEX IF NOT EXISTS idx_trivia_resultados_lead ON public.trivia_resultados(lead_id);

-- =====================================================
-- 2. APLICAR SEGURIDAD (RLS)
-- =====================================================

-- 2.1 Habilitar RLS
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trivia_resultados ENABLE ROW LEVEL SECURITY;

-- Nota: Si da error de "ya existe la policy", lo ignoramos borrándola primero
DROP POLICY IF EXISTS "Public leads insert" ON public.leads;
DROP POLICY IF EXISTS "Public trivia results insert" ON public.trivia_resultados;
DROP POLICY IF EXISTS "Instructores visibles para todos" ON public.instructores;

-- 2.2 Política para LEADS (Insertar público, Nadie lee)
CREATE POLICY "Public leads insert"
ON public.leads
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- 2.3 Política para RESULTADOS (Insertar público)
CREATE POLICY "Public trivia results insert"
ON public.trivia_resultados
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- 2.4 Política para INSTRUCTORES (Lectura pública si están activos)
-- Aseguramos que la tabla instructores exista primero (por si acaso)
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
ALTER TABLE public.instructores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Instructores visibles para todos"
ON public.instructores
FOR SELECT
TO anon, authenticated
USING (activo = TRUE);

-- =====================================================
-- 3. VALIDACIONES DE SEGURIDAD (Triggers)
-- =====================================================

CREATE OR REPLACE FUNCTION public.validar_email()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email !~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' THEN
    RAISE EXCEPTION 'Email inválido';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_validar_email_leads ON public.leads;
CREATE TRIGGER tr_validar_email_leads
  BEFORE INSERT OR UPDATE ON public.leads
  FOR EACH ROW EXECUTE FUNCTION public.validar_email();

