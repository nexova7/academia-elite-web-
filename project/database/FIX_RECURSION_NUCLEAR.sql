-- SCRIPT "NUCLEAR" DE LIMPIEZA DE POLÍTICAS (FIX_RECURSION_NUCLEAR.sql)
-- Este script ELIMINA TODAS las políticas de seguridad de la tabla 'alumnos' y las recrea desde cero.
-- Esto garantiza eliminar cualquier política "fantasma" que esté causando la recursión.

DO $$
DECLARE
    pol RECORD;
BEGIN
    -- Recorrer y borrar TODAS las políticas activas en la tabla 'alumnos'
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'alumnos' AND schemaname = 'public'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.alumnos', pol.policyname);
    END LOOP;
END $$;

-- Ahora que la tabla está limpia, creamos las 3 políticas esenciales (SIN RECURSIÓN)

-- 1. SOLO LECTURA: Ver mi propio perfil
CREATE POLICY "policy_select_own_profile" ON public.alumnos 
FOR SELECT USING (auth.uid() = id);

-- 2. SOLO ACTUALIZACIÓN: Editar mi propio perfil
CREATE POLICY "policy_update_own_profile" ON public.alumnos 
FOR UPDATE USING (auth.uid() = id);

-- 3. SOLO INSERCIÓN: Crear mi propio perfil (si el trigger falla)
CREATE POLICY "policy_insert_own_profile" ON public.alumnos 
FOR INSERT WITH CHECK (auth.uid() = id);

-- Confirmación de éxito
SELECT 'LIMPIEZA DE POLÍTICAS Y REPARACIÓN COMPLETA' as resultado;
