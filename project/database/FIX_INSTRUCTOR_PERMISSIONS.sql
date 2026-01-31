-- ==========================================
-- FIX PERMISOS DASHBOARD INSTRUCTOR v1
-- ==========================================
-- Objetivo: Permitir que el Dashboard de Instructores (que corre como anónimo en JS)
-- pueda leer todas las reservas y alumnos para mostrarlos en la UI.
-- Nota: Esto abre la lectura de agenda pero permite el funcionamiento sin login Auth de Supabase.

-- 1. Habilitar lectura de reservas para ANON
DROP POLICY IF EXISTS "Lectura publica de reservas para instructores" ON public.reservas_clases;
DROP POLICY IF EXISTS "Ver reservas propias" ON public.reservas_clases; -- Reemplazamos políticas restrictivas anteriores por ahora

CREATE POLICY "Lectura publica de reservas para instructores"
ON public.reservas_clases
FOR SELECT
TO anon, authenticated
USING (true);

-- 2. Habilitar actualización de reservas (notas, cancelar) para ANON
-- OJO: Esto permite que cualquiera edite notas. En producción ideal usaríamos Auth.
-- Por ahora para desbloquear funcionalidad:
DROP POLICY IF EXISTS "Update anonimo reservas" ON public.reservas_clases;

CREATE POLICY "Update anonimo reservas"
ON public.reservas_clases
FOR UPDATE
TO anon, authenticated
USING (true)
WITH CHECK (true);


-- 3. Habilitar lectura de alumnos para ANON (para el buscador del instructor)
DROP POLICY IF EXISTS "Lectura publica alumnos" ON public.alumnos;
-- Cuidado con datos sensibles. Solo lectura.

CREATE POLICY "Lectura publica alumnos"
ON public.alumnos
FOR SELECT
TO anon, authenticated
USING (true);
