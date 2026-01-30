-- =====================================================
-- ACADEMIA DE CONDUCCIÓN ÉLITE
-- Esquema Unificado de Base de Datos
-- Version: 2.0 UNIFIED
-- Database: PostgreSQL / Supabase
-- =====================================================

-- =====================================================
-- 1. CONFIGURACIÓN INICIAL
-- =====================================================

-- Crear esquema si no existe (para PostgreSQL local)
-- En Supabase, usar el esquema 'public' por defecto
CREATE SCHEMA IF NOT EXISTS academia_elite;
SET search_path TO academia_elite, public;

-- =====================================================
-- 2. TABLAS PRINCIPALES - USUARIOS Y AUTENTICACIÓN
-- =====================================================

-- 2.1 TABLA: alumnos
-- Descripción: Perfiles de estudiantes vinculados a Supabase Auth
-- Relación: 1:1 con auth.users (Supabase)
CREATE TABLE IF NOT EXISTS alumnos (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    whatsapp VARCHAR(20),
    categoria VARCHAR(10) NOT NULL CHECK (categoria IN ('B1', 'B2', 'C1', 'C2', 'A1', 'A2')),
    avatar_url TEXT,
    clases_completadas INT DEFAULT 0 CHECK (clases_completadas >= 0),
    puntaje_trivia DECIMAL(5,2) DEFAULT 0 CHECK (puntaje_trivia >= 0 AND puntaje_trivia <= 100),
    progreso DECIMAL(5,2) DEFAULT 0 CHECK (progreso >= 0 AND progreso <= 100),
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE alumnos IS 'Perfiles de estudiantes registrados en la academia';
COMMENT ON COLUMN alumnos.categoria IS 'Categoría de licencia: B1 (automóvil), C1 (camión), etc.';
COMMENT ON COLUMN alumnos.progreso IS 'Porcentaje de progreso hacia obtención de licencia';

-- 2.2 TABLA: instructores
-- Descripción: Perfiles de instructores de la academia
CREATE TABLE IF NOT EXISTS instructores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    especialidad VARCHAR(100),
    foto_url TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_contratacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE instructores IS 'Instructores de conducción de la academia';
COMMENT ON COLUMN instructores.especialidad IS 'Ej: Conducción Defensiva, Conducción Deportiva, Manejo en Carretera';

-- 2.3 TABLA: leads
-- Descripción: Usuarios potenciales antes de registrarse (Marketing)
CREATE TABLE IF NOT EXISTS leads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    origen VARCHAR(50) DEFAULT 'WEB', -- 'WEB', 'TRIVIA', 'REFERIDO', 'WHATSAPP'
    convertido BOOLEAN DEFAULT FALSE, -- TRUE si se convirtió en alumno
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE leads IS 'Leads de marketing antes de convertirse en alumnos';
COMMENT ON COLUMN leads.convertido IS 'Indica si el lead se registró como alumno';

-- =====================================================
-- 3. TABLAS ACADÉMICAS
-- =====================================================

-- 3.1 TABLA: servicios
-- Descripción: Catálogo de cursos y servicios ofrecidos
CREATE TABLE IF NOT EXISTS servicios (
    id SERIAL PRIMARY KEY,
    nombre_curso VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(12,2) NOT NULL CHECK (precio >= 0),
    categoria_licencia VARCHAR(10) NOT NULL,
    duracion_horas INT NOT NULL CHECK (duracion_horas > 0),
    nivel_dificultad VARCHAR(20) CHECK (nivel_dificultad IN ('Principiante', 'Intermedio', 'Avanzado')),
    imagen_url TEXT,
    activo BOOLEAN DEFAULT TRUE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE servicios IS 'Catálogo de cursos de conducción disponibles';
COMMENT ON COLUMN servicios.categoria_licencia IS 'Categoría de licencia para la que aplica el curso';

-- 3.2 TABLA: reservas_clases
-- Descripción: Reservas de clases prácticas
CREATE TABLE IF NOT EXISTS reservas_clases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alumno_id UUID NOT NULL REFERENCES alumnos(id) ON DELETE CASCADE,
    instructor VARCHAR(150) NOT NULL, -- Puede ser FK a instructores.nombre
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'CONFIRMADA' CHECK (estado IN ('CONFIRMADA', 'COMPLETADA', 'CANCELADA')),
    notas TEXT,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT no_domingos CHECK (EXTRACT(DOW FROM fecha) != 0),
    CONSTRAINT fecha_futura CHECK (fecha >= CURRENT_DATE)
);

COMMENT ON TABLE reservas_clases IS 'Reservas de clases prácticas de conducción';
COMMENT ON CONSTRAINT no_domingos ON reservas_clases IS 'No se permiten clases los domingos';

-- 3.3 TABLA: matriculas
-- Descripción: Inscripciones de alumnos en cursos
CREATE TABLE IF NOT EXISTS matriculas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alumno_id UUID NOT NULL REFERENCES alumnos(id) ON DELETE CASCADE,
    servicio_id INT NOT NULL REFERENCES servicios(id),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(20) DEFAULT 'ACTIVA' CHECK (estado IN ('ACTIVA', 'COMPLETADA', 'CANCELADA', 'SUSPENDIDA')),
    progreso_porcentaje DECIMAL(5,2) DEFAULT 0 CHECK (progreso_porcentaje >= 0 AND progreso_porcentaje <= 100),
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT fechas_validas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

COMMENT ON TABLE matriculas IS 'Inscripciones de alumnos en cursos específicos';

-- =====================================================
-- 4. SISTEMA DE TRIVIA
-- =====================================================

-- 4.1 TABLA: trivia_preguntas
-- Descripción: Preguntas del sistema de trivia
CREATE TABLE IF NOT EXISTS trivia_preguntas (
    id SERIAL PRIMARY KEY,
    pregunta TEXT NOT NULL,
    categoria VARCHAR(50), -- 'SEÑALES', 'NORMAS', 'MECÁNICA', 'SEGURIDAD'
    dificultad VARCHAR(20) CHECK (dificultad IN ('Fácil', 'Media', 'Difícil')),
    explicacion TEXT,
    activa BOOLEAN DEFAULT TRUE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE trivia_preguntas IS 'Preguntas para el sistema de trivia de captación';

-- 4.2 TABLA: trivia_opciones
-- Descripción: Opciones de respuesta para cada pregunta
CREATE TABLE IF NOT EXISTS trivia_opciones (
    id SERIAL PRIMARY KEY,
    pregunta_id INT NOT NULL REFERENCES trivia_preguntas(id) ON DELETE CASCADE,
    texto_opcion TEXT NOT NULL,
    es_correcta BOOLEAN DEFAULT FALSE,
    orden INT DEFAULT 1,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE trivia_opciones IS 'Opciones de respuesta múltiple para preguntas de trivia';

-- 4.3 TABLA: trivia_resultados
-- Descripción: Resultados de intentos de trivia
CREATE TABLE IF NOT EXISTS trivia_resultados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lead_id UUID REFERENCES leads(id) ON DELETE SET NULL,
    puntuacion_porcentaje DECIMAL(5,2) NOT NULL CHECK (puntuacion_porcentaje >= 0 AND puntuacion_porcentaje <= 100),
    nivel_alcanzado VARCHAR(50), -- 'PILOTO ÉLITE', 'ASPIRANTE', 'NOVATO'
    respuestas_correctas INT,
    total_preguntas INT,
    tiempo_segundos INT,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE trivia_resultados IS 'Registro de intentos y resultados de trivia';

-- =====================================================
-- 5. TABLAS DE NEGOCIO
-- =====================================================

-- 5.1 TABLA: pagos
-- Descripción: Registro de pagos realizados
CREATE TABLE IF NOT EXISTS pagos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    matricula_id UUID REFERENCES matriculas(id) ON DELETE SET NULL,
    alumno_id UUID REFERENCES alumnos(id) ON DELETE SET NULL,
    monto DECIMAL(12,2) NOT NULL CHECK (monto > 0),
    metodo_pago VARCHAR(50), -- 'EFECTIVO', 'TARJETA', 'TRANSFERENCIA', 'PSE'
    referencia VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'COMPLETADO' CHECK (estado IN ('PENDIENTE', 'COMPLETADO', 'RECHAZADO', 'REEMBOLSADO')),
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_pago TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE pagos IS 'Registro de transacciones de pago';

-- =====================================================
-- 6. ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices en alumnos
CREATE INDEX IF NOT EXISTS idx_alumnos_email ON alumnos(email);
CREATE INDEX IF NOT EXISTS idx_alumnos_categoria ON alumnos(categoria);
CREATE INDEX IF NOT EXISTS idx_alumnos_activo ON alumnos(activo) WHERE activo = TRUE;

-- Índices en reservas_clases
CREATE INDEX IF NOT EXISTS idx_reservas_alumno ON reservas_clases(alumno_id);
CREATE INDEX IF NOT EXISTS idx_reservas_fecha ON reservas_clases(fecha);
CREATE INDEX IF NOT EXISTS idx_reservas_estado ON reservas_clases(estado);
CREATE INDEX IF NOT EXISTS idx_reservas_fecha_hora ON reservas_clases(fecha, hora);

-- Índices en trivia
CREATE INDEX IF NOT EXISTS idx_trivia_opciones_pregunta ON trivia_opciones(pregunta_id);
CREATE INDEX IF NOT EXISTS idx_trivia_preguntas_activa ON trivia_preguntas(activa) WHERE activa = TRUE;
CREATE INDEX IF NOT EXISTS idx_trivia_resultados_lead ON trivia_resultados(lead_id);

-- Índices en matriculas
CREATE INDEX IF NOT EXISTS idx_matriculas_alumno ON matriculas(alumno_id);
CREATE INDEX IF NOT EXISTS idx_matriculas_servicio ON matriculas(servicio_id);
CREATE INDEX IF NOT EXISTS idx_matriculas_estado ON matriculas(estado);

-- Índices en leads
CREATE INDEX IF NOT EXISTS idx_leads_email ON leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_convertido ON leads(convertido) WHERE convertido = FALSE;

-- Índices en instructores
CREATE INDEX IF NOT EXISTS idx_instructores_activo ON instructores(activo) WHERE activo = TRUE;

-- =====================================================
-- 7. FUNCIONES Y TRIGGERS
-- =====================================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a tablas relevantes
CREATE TRIGGER update_alumnos_updated_at BEFORE UPDATE ON alumnos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_instructores_updated_at BEFORE UPDATE ON instructores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_servicios_updated_at BEFORE UPDATE ON servicios
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reservas_updated_at BEFORE UPDATE ON reservas_clases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_matriculas_updated_at BEFORE UPDATE ON matriculas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 8. ROW LEVEL SECURITY (RLS) - SUPABASE
-- =====================================================

-- Habilitar RLS en tablas sensibles
ALTER TABLE alumnos ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas_clases ENABLE ROW LEVEL SECURITY;
ALTER TABLE matriculas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

-- Políticas para alumnos: solo pueden ver/editar su propio perfil
CREATE POLICY "Alumnos pueden ver su propio perfil"
    ON alumnos FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Alumnos pueden actualizar su propio perfil"
    ON alumnos FOR UPDATE
    USING (auth.uid() = id);

-- Políticas para reservas_clases: solo pueden ver/gestionar sus propias reservas
CREATE POLICY "Alumnos pueden ver sus propias reservas"
    ON reservas_clases FOR SELECT
    USING (auth.uid() = alumno_id);

CREATE POLICY "Alumnos pueden crear sus propias reservas"
    ON reservas_clases FOR INSERT
    WITH CHECK (auth.uid() = alumno_id);

CREATE POLICY "Alumnos pueden cancelar sus propias reservas"
    ON reservas_clases FOR DELETE
    USING (auth.uid() = alumno_id);

-- Políticas para matriculas: solo pueden ver sus propias matrículas
CREATE POLICY "Alumnos pueden ver sus propias matrículas"
    ON matriculas FOR SELECT
    USING (auth.uid() = alumno_id);

-- Políticas para pagos: solo pueden ver sus propios pagos
CREATE POLICY "Alumnos pueden ver sus propios pagos"
    ON pagos FOR SELECT
    USING (auth.uid() = alumno_id);

-- Políticas para tablas públicas (lectura para todos autenticados)
ALTER TABLE servicios ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Servicios son visibles para todos"
    ON servicios FOR SELECT
    TO authenticated
    USING (activo = TRUE);

ALTER TABLE instructores ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Instructores activos son visibles para todos"
    ON instructores FOR SELECT
    TO authenticated
    USING (activo = TRUE);

ALTER TABLE trivia_preguntas ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Preguntas activas son visibles para todos"
    ON trivia_preguntas FOR SELECT
    TO anon, authenticated
    USING (activa = TRUE);

ALTER TABLE trivia_opciones ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Opciones son visibles para todos"
    ON trivia_opciones FOR SELECT
    TO anon, authenticated
    USING (TRUE);

-- =====================================================
-- FIN DEL ESQUEMA UNIFICADO
-- =====================================================
