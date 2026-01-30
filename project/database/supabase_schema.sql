-- =====================================================
-- ACADEMIA DE CONDUCCIÓN ÉLITE
-- Esquema para SUPABASE
-- URL: https://aldwcqpgsjfjcttxfecp.supabase.co
-- Version: 2.0 SUPABASE
-- =====================================================

-- IMPORTANTE: Este script está optimizado para Supabase
-- Ejecutar en: SQL Editor de Supabase Dashboard

-- =====================================================
-- 1. TABLAS PRINCIPALES - USUARIOS Y AUTENTICACIÓN
-- =====================================================

-- 1.1 TABLA: alumnos
-- Vinculada a auth.users de Supabase
CREATE TABLE IF NOT EXISTS public.alumnos (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    whatsapp VARCHAR(20),
    categoria VARCHAR(10) NOT NULL CHECK (categoria IN ('B1', 'B2', 'C1', 'C2', 'A1', 'A2')),
    avatar_url TEXT,
    clases_completadas INT DEFAULT 0 CHECK (clases_completadas >= 0),
    puntaje_trivia DECIMAL(5,2) DEFAULT 0 CHECK (puntaje_trivia >= 0 AND puntaje_trivia <= 100),
    progreso DECIMAL(5,2) DEFAULT 0 CHECK (progreso >= 0 AND progreso <= 100),
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE public.alumnos IS 'Perfiles de estudiantes registrados';

-- 1.2 TABLA: instructores
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

COMMENT ON TABLE public.instructores IS 'Instructores de la academia';

-- 1.3 TABLA: leads
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

COMMENT ON TABLE public.leads IS 'Leads de marketing antes de registro';

-- =====================================================
-- 2. TABLAS ACADÉMICAS
-- =====================================================

-- 2.1 TABLA: servicios
CREATE TABLE IF NOT EXISTS public.servicios (
    id SERIAL PRIMARY KEY,
    nombre_curso VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(12,2) NOT NULL CHECK (precio >= 0),
    categoria_licencia VARCHAR(10) NOT NULL,
    duracion_horas INT NOT NULL CHECK (duracion_horas > 0),
    nivel_dificultad VARCHAR(20) CHECK (nivel_dificultad IN ('Principiante', 'Intermedio', 'Avanzado')),
    imagen_url TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE public.servicios IS 'Catálogo de cursos disponibles';

-- 2.2 TABLA: reservas_clases
CREATE TABLE IF NOT EXISTS public.reservas_clases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alumno_id UUID NOT NULL REFERENCES public.alumnos(id) ON DELETE CASCADE,
    instructor VARCHAR(150) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'CONFIRMADA' CHECK (estado IN ('CONFIRMADA', 'COMPLETADA', 'CANCELADA')),
    notas TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT no_domingos CHECK (EXTRACT(DOW FROM fecha) != 0),
    CONSTRAINT fecha_futura CHECK (fecha >= CURRENT_DATE)
);

COMMENT ON TABLE public.reservas_clases IS 'Reservas de clases prácticas';

-- 2.3 TABLA: matriculas
CREATE TABLE IF NOT EXISTS public.matriculas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alumno_id UUID NOT NULL REFERENCES public.alumnos(id) ON DELETE CASCADE,
    servicio_id INT NOT NULL REFERENCES public.servicios(id),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(20) DEFAULT 'ACTIVA' CHECK (estado IN ('ACTIVA', 'COMPLETADA', 'CANCELADA', 'SUSPENDIDA')),
    progreso_porcentaje DECIMAL(5,2) DEFAULT 0 CHECK (progreso_porcentaje >= 0 AND progreso_porcentaje <= 100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fechas_validas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

COMMENT ON TABLE public.matriculas IS 'Inscripciones de alumnos en cursos';

-- =====================================================
-- 3. SISTEMA DE TRIVIA
-- =====================================================

-- 3.1 TABLA: trivia_preguntas
CREATE TABLE IF NOT EXISTS public.trivia_preguntas (
    id SERIAL PRIMARY KEY,
    pregunta TEXT NOT NULL,
    categoria VARCHAR(50),
    dificultad VARCHAR(20) CHECK (dificultad IN ('Fácil', 'Media', 'Difícil')),
    explicacion TEXT,
    activa BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE public.trivia_preguntas IS 'Preguntas del sistema de trivia';

-- 3.2 TABLA: trivia_opciones
CREATE TABLE IF NOT EXISTS public.trivia_opciones (
    id SERIAL PRIMARY KEY,
    pregunta_id INT NOT NULL REFERENCES public.trivia_preguntas(id) ON DELETE CASCADE,
    texto_opcion TEXT NOT NULL,
    es_correcta BOOLEAN DEFAULT FALSE,
    orden INT DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE public.trivia_opciones IS 'Opciones de respuesta para trivia';

-- 3.3 TABLA: trivia_resultados
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

COMMENT ON TABLE public.trivia_resultados IS 'Resultados de intentos de trivia';

-- =====================================================
-- 4. TABLAS DE NEGOCIO
-- =====================================================

-- 4.1 TABLA: pagos
CREATE TABLE IF NOT EXISTS public.pagos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    matricula_id UUID REFERENCES public.matriculas(id) ON DELETE SET NULL,
    alumno_id UUID REFERENCES public.alumnos(id) ON DELETE SET NULL,
    monto DECIMAL(12,2) NOT NULL CHECK (monto > 0),
    metodo_pago VARCHAR(50),
    referencia VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'COMPLETADO' CHECK (estado IN ('PENDIENTE', 'COMPLETADO', 'RECHAZADO', 'REEMBOLSADO')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_pago TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE public.pagos IS 'Registro de transacciones de pago';

-- =====================================================
-- 5. ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_alumnos_email ON public.alumnos(email);
CREATE INDEX IF NOT EXISTS idx_alumnos_categoria ON public.alumnos(categoria);
CREATE INDEX IF NOT EXISTS idx_alumnos_activo ON public.alumnos(activo) WHERE activo = TRUE;

CREATE INDEX IF NOT EXISTS idx_reservas_alumno ON public.reservas_clases(alumno_id);
CREATE INDEX IF NOT EXISTS idx_reservas_fecha ON public.reservas_clases(fecha);
CREATE INDEX IF NOT EXISTS idx_reservas_estado ON public.reservas_clases(estado);
CREATE INDEX IF NOT EXISTS idx_reservas_fecha_hora ON public.reservas_clases(fecha, hora);

CREATE INDEX IF NOT EXISTS idx_trivia_opciones_pregunta ON public.trivia_opciones(pregunta_id);
CREATE INDEX IF NOT EXISTS idx_trivia_preguntas_activa ON public.trivia_preguntas(activa) WHERE activa = TRUE;
CREATE INDEX IF NOT EXISTS idx_trivia_resultados_lead ON public.trivia_resultados(lead_id);

CREATE INDEX IF NOT EXISTS idx_matriculas_alumno ON public.matriculas(alumno_id);
CREATE INDEX IF NOT EXISTS idx_matriculas_servicio ON public.matriculas(servicio_id);
CREATE INDEX IF NOT EXISTS idx_matriculas_estado ON public.matriculas(estado);

CREATE INDEX IF NOT EXISTS idx_leads_email ON public.leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_convertido ON public.leads(convertido) WHERE convertido = FALSE;

CREATE INDEX IF NOT EXISTS idx_instructores_activo ON public.instructores(activo) WHERE activo = TRUE;

-- =====================================================
-- 6. FUNCIONES Y TRIGGERS
-- =====================================================

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para auto-actualizar updated_at
CREATE TRIGGER update_alumnos_updated_at 
    BEFORE UPDATE ON public.alumnos
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_instructores_updated_at 
    BEFORE UPDATE ON public.instructores
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_servicios_updated_at 
    BEFORE UPDATE ON public.servicios
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_reservas_updated_at 
    BEFORE UPDATE ON public.reservas_clases
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_matriculas_updated_at 
    BEFORE UPDATE ON public.matriculas
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- 7. ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Habilitar RLS en todas las tablas sensibles
ALTER TABLE public.alumnos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas_clases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matriculas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pagos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.servicios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.instructores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trivia_preguntas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trivia_opciones ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLÍTICAS RLS - ALUMNOS
-- =====================================================

-- Alumnos pueden ver su propio perfil
CREATE POLICY "Alumnos pueden ver su propio perfil"
    ON public.alumnos FOR SELECT
    USING (auth.uid() = id);

-- Alumnos pueden actualizar su propio perfil
CREATE POLICY "Alumnos pueden actualizar su propio perfil"
    ON public.alumnos FOR UPDATE
    USING (auth.uid() = id);

-- Permitir inserción desde el registro (auth trigger)
CREATE POLICY "Permitir inserción de nuevos alumnos"
    ON public.alumnos FOR INSERT
    WITH CHECK (auth.uid() = id);

-- =====================================================
-- POLÍTICAS RLS - RESERVAS_CLASES
-- =====================================================

-- Ver solo sus propias reservas
CREATE POLICY "Alumnos pueden ver sus propias reservas"
    ON public.reservas_clases FOR SELECT
    USING (auth.uid() = alumno_id);

-- Crear solo sus propias reservas
CREATE POLICY "Alumnos pueden crear sus propias reservas"
    ON public.reservas_clases FOR INSERT
    WITH CHECK (auth.uid() = alumno_id);

-- Actualizar solo sus propias reservas
CREATE POLICY "Alumnos pueden actualizar sus propias reservas"
    ON public.reservas_clases FOR UPDATE
    USING (auth.uid() = alumno_id);

-- Eliminar solo sus propias reservas
CREATE POLICY "Alumnos pueden cancelar sus propias reservas"
    ON public.reservas_clases FOR DELETE
    USING (auth.uid() = alumno_id);

-- =====================================================
-- POLÍTICAS RLS - MATRICULAS
-- =====================================================

-- Ver solo sus propias matrículas
CREATE POLICY "Alumnos pueden ver sus propias matrículas"
    ON public.matriculas FOR SELECT
    USING (auth.uid() = alumno_id);

-- =====================================================
-- POLÍTICAS RLS - PAGOS
-- =====================================================

-- Ver solo sus propios pagos
CREATE POLICY "Alumnos pueden ver sus propios pagos"
    ON public.pagos FOR SELECT
    USING (auth.uid() = alumno_id);

-- =====================================================
-- POLÍTICAS RLS - SERVICIOS (Público)
-- =====================================================

-- Todos los usuarios autenticados pueden ver servicios activos
CREATE POLICY "Servicios activos son visibles para todos"
    ON public.servicios FOR SELECT
    TO authenticated
    USING (activo = TRUE);

-- Usuarios anónimos también pueden ver servicios (para página pública)
CREATE POLICY "Servicios visibles para anónimos"
    ON public.servicios FOR SELECT
    TO anon
    USING (activo = TRUE);

-- =====================================================
-- POLÍTICAS RLS - INSTRUCTORES (Público)
-- =====================================================

-- Instructores activos visibles para autenticados
CREATE POLICY "Instructores activos visibles para autenticados"
    ON public.instructores FOR SELECT
    TO authenticated
    USING (activo = TRUE);

-- =====================================================
-- POLÍTICAS RLS - TRIVIA (Público)
-- =====================================================

-- Preguntas activas visibles para todos (incluido anónimos)
CREATE POLICY "Preguntas activas visibles para todos"
    ON public.trivia_preguntas FOR SELECT
    TO anon, authenticated
    USING (activa = TRUE);

-- Opciones visibles para todos
CREATE POLICY "Opciones visibles para todos"
    ON public.trivia_opciones FOR SELECT
    TO anon, authenticated
    USING (TRUE);

-- =====================================================
-- FIN DEL ESQUEMA SUPABASE
-- =====================================================

-- NOTA: Después de ejecutar este script, ejecutar seed_data.sql
