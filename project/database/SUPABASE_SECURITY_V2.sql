-- =====================================================
-- ESTRATEGIA DE SEGURIDAD MÁXIMA - SUPABASE
-- ACADEMIA DE CONDUCCIÓN ÉLITE
-- =====================================================

-- 1. HABILITAR RLS EN TABLAS FALTANTES
-- Importante: Leads contiene datos personales (PII)
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trivia_resultados ENABLE ROW LEVEL SECURITY;

-- 2. POLÍTICAS PARA LEADS (Marketing)
-- Permitir que CUALQUIERA (anon) pueda registrarse como lead
CREATE POLICY "Public leads insert"
ON public.leads
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- NADIE puede ver los leads desde el cliente (solo admin vía dashboard/service_role)
-- No creamos políticas de SELECT, UPDATE, DELETE para leads por defecto.
-- Esto protege la base de datos de "scraping" de leads.

-- 3. POLÍTICAS PARA RESULTADOS TRIVIA
-- Permitir guardar resultados
CREATE POLICY "Public trivia results insert"
ON public.trivia_resultados
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- Solo ver resultados propios (si se relacionan con un lead o usuario)
-- Si el usuario es anónimo y no guarda sesión, difícilmente podrá ver su historial.
-- Por seguridad, mejor solo permitir insertar por ahora.

-- 4. REFORZAR POLÍTICAS EXISTENTES (Audit)

-- Asegurar que 'instructores' sea legible por pública si es necesario para el Landing
-- Si ya existe (en supabase_schema.sql solía ser solo authenticated), la ajustamos:
DROP POLICY IF EXISTS "Instructores activos visibles para autenticados" ON public.instructores;

CREATE POLICY "Instructores visibles para todos"
ON public.instructores
FOR SELECT
TO anon, authenticated
USING (activo = TRUE);

-- =====================================================
-- 5. FUNCIONES DE SEGURIDAD AVANZADA
-- =====================================================

-- Función para validar email en el servidor (evitar emails falsos 'mal formados' simples)
-- Supabase Auth ya valida emails de usuarios, pero para leads/tablas custom:
CREATE OR REPLACE FUNCTION public.validar_email()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email !~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' THEN
    RAISE EXCEPTION 'Email inválido';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para leads
DROP TRIGGER IF EXISTS tr_validar_email_leads ON public.leads;
CREATE TRIGGER tr_validar_email_leads
  BEFORE INSERT OR UPDATE ON public.leads
  FOR EACH ROW EXECUTE FUNCTION public.validar_email();

-- Trigger para alumnos (aunque Auth lo maneja, doble validación no sobra)
DROP TRIGGER IF EXISTS tr_validar_email_alumnos ON public.alumnos;
CREATE TRIGGER tr_validar_email_alumnos
  BEFORE INSERT OR UPDATE ON public.alumnos
  FOR EACH ROW EXECUTE FUNCTION public.validar_email();

