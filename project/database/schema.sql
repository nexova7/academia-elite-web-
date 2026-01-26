-- Academia de Conducción Élite
-- Schema Version: 1.0.0
-- RDBMS: PostgreSQL

-- 1. Tablas de Configuración (Lookup Tables)
CREATE TABLE difficulty_levels (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE, -- 'BEGINNER', 'ADVANCED', 'PRO'
    label VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla de Leads (Usuarios Potenciales)
CREATE TABLE leads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    marketing_consent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Preguntas de Trivia
CREATE TABLE trivia_questions (
    id SERIAL PRIMARY KEY,
    difficulty_id INT REFERENCES difficulty_levels(id),
    question_text TEXT NOT NULL,
    correct_answer_id INT, -- Se rellena después de insertar opciones
    explanation TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Opciones de Respuesta
CREATE TABLE question_options (
    id SERIAL PRIMARY KEY,
    question_id INT REFERENCES trivia_questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE
);

-- 5. Resultados de Intentos
CREATE TABLE quiz_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lead_id UUID REFERENCES leads(id),
    score_percentage DECIMAL(5,2) NOT NULL,
    difficulty_level_attempted VARCHAR(20),
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Catálogo de Servicios (Cursos)
CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration_hours INT,
    difficulty_id INT REFERENCES difficulty_levels(id),
    is_active BOOLEAN DEFAULT TRUE
);

-- 7. Órdenes de Compra
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(20) UNIQUE NOT NULL, -- e.g. ORD-2026-001
    lead_id UUID REFERENCES leads(id),
    service_id INT REFERENCES services(id),
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, COMPLETED, CANCELLED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Pagos (Simplificado)
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50), -- CARD, TRANSFER
    transaction_ref VARCHAR(100),
    status VARCHAR(20) DEFAULT 'SUCCESS',
    paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para optimización
CREATE INDEX idx_leads_email ON leads(email);
CREATE INDEX idx_questions_diff ON trivia_questions(difficulty_id);
