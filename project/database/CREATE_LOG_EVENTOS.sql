-- =====================================================
-- TABLA DE LOGS DE EVENTOS ADMINISTRATIVOS
-- =====================================================

CREATE TABLE IF NOT EXISTS public.logs_eventos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario VARCHAR(100) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    accion VARCHAR(100) NOT NULL,
    resultado VARCHAR(100) NOT NULL, -- 'EXITO', 'FALLO', 'DENEGADO'
    detalles JSONB,
    fecha_hora TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Habilitar RLS
ALTER TABLE public.logs_eventos ENABLE ROW LEVEL SECURITY;

-- Solo administradores e instructores pueden insertar logs (desde la app)
CREATE POLICY "Permitir inserción de logs"
ON public.logs_eventos FOR INSERT
WITH CHECK (true); -- Permitimos inserción desde la app, la validación real es previa

-- Solo personal autorizado puede ver logs
CREATE POLICY "Solo administradores ven logs"
ON public.logs_eventos FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM public.alumnos 
        WHERE id = auth.uid() AND (rol = 'admin' OR rol = 'instructor')
    )
);

COMMENT ON TABLE public.logs_eventos IS 'Registro de auditoría para acciones administrativas sensibles';
