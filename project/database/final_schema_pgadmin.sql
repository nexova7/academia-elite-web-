-- Academia de Conducción Élite
-- Script Final para pgAdmin 4
-- Version: 1.0 RELEASE

-- 1. Crear Esquema Propio
CREATE SCHEMA IF NOT EXISTS academia_elite;
SET search_path TO academia_elite;

-- 2. Tabla de Servicios (Catálogo)
-- Basado en visión del Diseñador
CREATE TABLE servicios (
    id SERIAL PRIMARY KEY,
    nombre_curso VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(12, 2) NOT NULL CHECK (precio >= 0),
    nivel_dificultad VARCHAR(50) NOT NULL, -- 'Principiante', 'Intermedio', 'Avanzado'
    duracion_horas INT,
    imagen_url VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE
);

-- 3. Tabla de Leads (Usuarios)
CREATE TABLE leads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabla de Resultados de Trivia
-- Guarda el desempeño del usuario y su clasificación
CREATE TABLE trivia_resultados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    puntuacion_porcentaje DECIMAL(5, 2) NOT NULL,
    nivel_alcanzado VARCHAR(50) NOT NULL, -- 'PILOTO ÉLITE' o 'ASPIRANTE'
    fecha_intento TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabla de Reservas (Booking System)
-- Vincula al Lead con el Servicio contratado
CREATE TABLE leads_reservas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo_reserva VARCHAR(20) UNIQUE NOT NULL, -- Ej: RES-2026-X89
    lead_id UUID REFERENCES leads(id),
    servicio_id INT REFERENCES servicios(id),
    monto_total DECIMAL(12, 2) NOT NULL,
    estado_pago VARCHAR(20) DEFAULT 'PENDIENTE', -- 'PENDIENTE', 'PAGADO', 'CANCELADO'
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Datos Semilla (Catálogo Inicial)
INSERT INTO servicios (nombre_curso, precio, nivel_dificultad, duracion_horas) VALUES
('Drift Basics: Control del Caos', 250000.00, 'Principiante', 4),
('Defensive Driving Pro', 320000.00, 'Intermedio', 6),
('Track Master: Apex Hunter', 850000.00, 'Avanzado', 12);

-- Índices
CREATE INDEX idx_leads_email ON leads(email);
CREATE INDEX idx_reservas_codigo ON leads_reservas(codigo_reserva);
