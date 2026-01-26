-- Script de Seguridad: Estrategia "Centinela" (RBAC Completo)
-- Objetivo: Definir roles jerárquicos y usuarios de plantilla para la Academia Élite.

-- 0. Limpieza Previa (Opcional, usar con cuidado en producción)
-- DROP ROLE IF EXISTS rol_elite_admin, rol_elite_app, rol_elite_auditor;

-- 1. Definición de ROLES (Grupos de Permisos)

-- A. ROL ADMIN (Mantenimiento total)
CREATE ROLE rol_elite_admin;
-- Permisos:
GRANT ALL PRIVILEGES ON DATABASE postgres TO rol_elite_admin;
GRANT ALL PRIVILEGES ON SCHEMA academia_elite TO rol_elite_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA academia_elite TO rol_elite_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA academia_elite TO rol_elite_admin;

-- B. ROL APP (La Aplicación Web)
CREATE ROLE rol_elite_app;
GRANT CONNECT ON DATABASE postgres TO rol_elite_app;
GRANT USAGE ON SCHEMA academia_elite TO rol_elite_app;
-- CRUD Operativo:
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE academia_elite.leads TO rol_elite_app;
GRANT SELECT, INSERT, UPDATE ON TABLE academia_elite.leads_reservas TO rol_elite_app;
GRANT SELECT, INSERT ON TABLE academia_elite.trivia_resultados TO rol_elite_app;
GRANT SELECT ON TABLE academia_elite.servicios TO rol_elite_app; -- Solo lectura del catálogo
-- Secuencias (Para poder insertar):
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA academia_elite TO rol_elite_app;

-- C. ROL AUDITOR (Solo Lectura - Análisis)
CREATE ROLE rol_elite_auditor;
GRANT CONNECT ON DATABASE postgres TO rol_elite_auditor;
GRANT USAGE ON SCHEMA academia_elite TO rol_elite_auditor;
-- Read-Only universal en el esquema:
GRANT SELECT ON ALL TABLES IN SCHEMA academia_elite TO rol_elite_auditor;

-- 2. Creación de USUARIOS PLANTILLA (Asignación a Roles)

-- Usuario para la Web App
CREATE USER user_app WITH PASSWORD 'app_secure_password_2026';
GRANT rol_elite_app TO user_app;

-- Usuario para Auditoría Externa
CREATE USER user_auditor WITH PASSWORD 'audit_view_only_99';
GRANT rol_elite_auditor TO user_auditor;

-- Usuario Admin (Supervisión Técnica)
CREATE USER admin_master WITH PASSWORD 'master_key_elite_v1';
GRANT rol_elite_admin TO admin_master;

-- 3. Revocación de Permisos Públicos (Harden)
REVOKE ALL ON SCHEMA academia_elite FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA academia_elite FROM PUBLIC;

-- Fin de la Estrategia Centinela
