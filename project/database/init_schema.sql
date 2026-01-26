-- Arquitecto de Datos: Script para Academia Élite
-- Base de Datos: PostgreSQL
-- Herramienta objetivo: pgAdmin 4

-- 1. Crear Schema
CREATE SCHEMA IF NOT EXISTS academia_elite;

-- 2. Tabla leads (Alumnos interesados)
CREATE TABLE IF NOT EXISTS academia_elite.leads (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'nuevo' CHECK (estado IN ('nuevo', 'contactado', 'convertido', 'descartado')),
    score_trivia INT DEFAULT 0
);

-- 3. Tabla servicios (Cursos de conducción)
CREATE TABLE IF NOT EXISTS academia_elite.servicios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio >= 0),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabla trivia_preguntas (Preguntas)
CREATE TABLE IF NOT EXISTS academia_elite.trivia_preguntas (
    id SERIAL PRIMARY KEY,
    texto_pregunta TEXT NOT NULL,
    categoria VARCHAR(50), -- e.g., 'Seguridad', 'Mecánica', 'Normas'
    nivel_dificultad INT DEFAULT 1 CHECK (nivel_dificultad BETWEEN 1 AND 3),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabla trivia_opciones (Respuestas) - Relación 1:N para 3FN
-- Se separa para no repetir datos y permitir N opciones por pregunta.
CREATE TABLE IF NOT EXISTS academia_elite.trivia_opciones (
    id SERIAL PRIMARY KEY,
    pregunta_id INT REFERENCES academia_elite.trivia_preguntas(id) ON DELETE CASCADE,
    texto_opcion TEXT NOT NULL,
    es_correcta BOOLEAN DEFAULT FALSE
);

-- Indices para optimización (Velocidad de consultas)
CREATE INDEX IF NOT EXISTS idx_leads_email ON academia_elite.leads(email);
CREATE INDEX IF NOT EXISTS idx_servicios_activo ON academia_elite.servicios(activo);
CREATE INDEX IF NOT EXISTS idx_trivia_preguntas_activo ON academia_elite.trivia_preguntas(activo);
CREATE INDEX IF NOT EXISTS idx_trivia_opciones_pregunta ON academia_elite.trivia_opciones(pregunta_id);

COMMENT ON SCHEMA academia_elite IS 'Esquema principal para la aplicación Academia Élite';
COMMENT ON TABLE academia_elite.leads IS 'Alumnos interesados captados por la web o trivia';
COMMENT ON TABLE academia_elite.servicios IS 'Catalogo de cursos de conducción disponibles';
COMMENT ON TABLE academia_elite.trivia_preguntas IS 'Banco de preguntas para la trivia de conducción';
