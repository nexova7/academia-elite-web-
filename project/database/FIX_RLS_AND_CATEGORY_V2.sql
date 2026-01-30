-- ==============================================================================
-- SCRIPT DE CORRECCIÓN: RLS RECURSIVO Y CATEGORÍA DE ALUMNO (V2 - A PRUEBA DE FALLOS)
-- ==============================================================================
-- Este script soluciona los problemas previos, eliminando CUALQUIER política conflictiva antes de crear nuevas.
-- ==============================================================================

-- 1. ELIMINAR POLÍTICAS EXISTENTES (LIMPIEZA TOTAL Y SEGURA)
-- Usamos bloques DO para evitar errores si las políticas no existen.
DO $$
BEGIN
    DROP POLICY IF EXISTS "Alumnos pueden ver su propio perfil" ON public.alumnos;
    DROP POLICY IF EXISTS "Alumnos pueden actualizar su propio perfil" ON public.alumnos;
    DROP POLICY IF EXISTS "Permitir inserción de nuevos alumnos" ON public.alumnos;
    -- Políticas anteriores que podrían causar conflictos
    DROP POLICY IF EXISTS "Alumnos pueden crear su propio perfil" ON public.alumnos; 
    DROP POLICY IF EXISTS "Users can see themselves" ON public.alumnos;
    DROP POLICY IF EXISTS "Users can update themselves" ON public.alumnos;
    DROP POLICY IF EXISTS "Admins can see all" ON public.alumnos;
EXCEPTION
    WHEN undefined_object THEN NULL;
END $$;

-- 2. RECREAR POLÍTICAS SEGURAS (SIN RECURSIÓN)
-- Permitir SELECT solo si el ID coincide con el usuario autenticado
CREATE POLICY "Alumnos pueden ver su propio perfil"
ON public.alumnos FOR SELECT
USING (auth.uid() = id);

-- Permitir UPDATE solo si el ID coincide
CREATE POLICY "Alumnos pueden actualizar su propio perfil"
ON public.alumnos FOR UPDATE
USING (auth.uid() = id);

-- Permitir INSERT solo si el ID coincide (para registro manual si falla el trigger)
CREATE POLICY "Alumnos pueden crear su propio perfil"
ON public.alumnos FOR INSERT
WITH CHECK (auth.uid() = id);

-- 3. AUTOMATIZAR CREACIÓN DE PERFIL (TRIGGER)
-- Asegura la creación automática de perfil al registrarse un usuario.

-- Función para manejar nuevo usuario
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.alumnos (id, email, nombre, categoria)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data->>'full_name', 'Nuevo Alumno'),
    'B1' -- Categoría por defecto
  )
  ON CONFLICT (id) DO NOTHING; -- Si ya existe, no hace nada
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger que se dispara cuando se crea un usuario en auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 4. CORREGIR DATOS EXISTENTES (AUTO-REPARACIÓN)
-- Busca usuarios sin perfil y lo crea.
INSERT INTO public.alumnos (id, email, nombre, categoria)
SELECT 
  id, 
  email, 
  COALESCE(raw_user_meta_data->>'full_name', 'Alumno Existente'), 
  'B1'
FROM auth.users
WHERE id NOT IN (SELECT id FROM public.alumnos)
ON CONFLICT (id) DO NOTHING;

-- Notificar éxito
SELECT 'CORRECCIONES APLICADAS EXITOSAMENTE (V2)' as status;
