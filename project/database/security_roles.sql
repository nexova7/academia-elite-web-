-- ESTRATEGIA CENTINELA: SISTEMA DE ROLES Y SEGURIDAD (RBAC)
-- Este script implementa la seguridad a nivel de base de datos PostgreSQL.
-- Debe ser ejecutado por un superusuario (postgres).

-- 1. LIMPIEZA DE PERMISOS (HARDENING)
-- Revocamos permisos por defecto en el esquema public para asegurar control total.
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;

-- Permitimos uso básico del esquema
GRANT USAGE ON SCHEMA public TO PUBLIC;

-- 2. CREACIÓN DE ROLES (JERARQUÍA CENTINELA)

-- ROL: ELITE ADMIN (Control Total)
-- Responsable: Mantenimiento, migraciones, DDL.
DO $$ 
BEGIN 
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'rol_elite_admin') THEN
    CREATE ROLE rol_elite_admin WITH NOLOGIN;
  END IF; 
END $$;

GRANT ALL PRIVILEGES ON SCHEMA public TO rol_elite_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rol_elite_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rol_elite_admin;

-- ROL: ELITE APP (La Aplicación)
-- Responsable: Operaciones CRUD diarias del sistema.
DO $$ 
BEGIN 
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'rol_elite_app') THEN
    CREATE ROLE rol_elite_app WITH NOLOGIN;
  END IF; 
END $$;

GRANT USAGE ON SCHEMA public TO rol_elite_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO rol_elite_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_elite_app;

-- ROL: ELITE AUDITOR (Solo Lectura)
-- Responsable: Auditoría, reportes, análisis de datos.
DO $$ 
BEGIN 
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'rol_elite_auditor') THEN
    CREATE ROLE rol_elite_auditor WITH NOLOGIN;
  END IF; 
END $$;

GRANT USAGE ON SCHEMA public TO rol_elite_auditor;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO rol_elite_auditor;

-- 3. GESTIÓN DE FUTURAS TABLAS
-- Asegura que las tablas nuevas hereden los permisos correspondientes

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO rol_elite_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO rol_elite_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO rol_elite_auditor;

-- 4. CREACIÓN DE USUARIOS DE SERVICIO (TEMPLATE USERS)
-- Estos son los usuarios que "usará" el backend o servicios externos.

-- Usuario para la Aplicación (Backend/API)
DO $$ 
BEGIN 
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'user_elite_app') THEN
    CREATE ROLE user_elite_app WITH LOGIN PASSWORD 'Elite_App_Secure_2026!';
    GRANT rol_elite_app TO user_elite_app;
  END IF; 
END $$;

-- Usuario para Auditoría (PowerBI / DataGrip / pgAdmin lectura)
DO $$ 
BEGIN 
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'user_elite_audit') THEN
    CREATE ROLE user_elite_audit WITH LOGIN PASSWORD 'Elite_Audit_View_Only!';
    GRANT rol_elite_auditor TO user_elite_audit;
  END IF; 
END $$;

-- 5. VALIDACIÓN DE SEGURIDAD (POLÍTICAS RLS EN SUPABASE)
-- Nota: En un entorno Supabase, estas políticas complementan los Roles de Postgres.
-- Asegurando que authenticator y service_role tengan acceso correcto (Supabase defaults).
GRANT rol_elite_app TO authenticated;
GRANT rol_elite_app TO service_role;
GRANT rol_elite_auditor TO anon; -- O limitar anon más si se desea.

-- FIN DE ESTRATEGIA CENTINELA
