-- =====================================================
-- ACADEMIA DE CONDUCCIÓN ÉLITE
-- Estrategia de Seguridad "Centinela 2.0"
-- Version: 2.0 UNIFIED
-- =====================================================

-- =====================================================
-- PARTE 1: SEGURIDAD PARA SUPABASE (RLS)
-- =====================================================

-- NOTA: Las políticas RLS ya están incluidas en unified_schema.sql
-- Este archivo documenta la estrategia completa de seguridad

-- =====================================================
-- PARTE 2: SEGURIDAD PARA POSTGRESQL LOCAL (RBAC)
-- =====================================================

-- 1. LIMPIEZA PREVIA (Solo si es necesario)
-- DROP ROLE IF EXISTS rol_elite_admin, rol_elite_app, rol_elite_auditor;
-- DROP USER IF EXISTS user_app, user_auditor, admin_master;

-- =====================================================
-- 2. DEFINICIÓN DE ROLES
-- =====================================================

-- ROL 1: ADMINISTRADOR (Acceso Total)
CREATE ROLE rol_elite_admin;
GRANT ALL PRIVILEGES ON DATABASE postgres TO rol_elite_admin;
GRANT ALL PRIVILEGES ON SCHEMA academia_elite TO rol_elite_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA academia_elite TO rol_elite_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA academia_elite TO rol_elite_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA academia_elite TO rol_elite_admin;

COMMENT ON ROLE rol_elite_admin IS 'Rol con acceso total para administración y mantenimiento';

-- ROL 2: APLICACIÓN WEB (CRUD Operativo)
CREATE ROLE rol_elite_app;
GRANT CONNECT ON DATABASE postgres TO rol_elite_app;
GRANT USAGE ON SCHEMA academia_elite TO rol_elite_app;

-- Permisos de lectura/escritura en tablas operativas
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE alumnos TO rol_elite_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE reservas_clases TO rol_elite_app;
GRANT SELECT, INSERT, UPDATE ON TABLE matriculas TO rol_elite_app;
GRANT SELECT, INSERT ON TABLE pagos TO rol_elite_app;
GRANT SELECT, INSERT ON TABLE leads TO rol_elite_app;
GRANT SELECT, INSERT ON TABLE trivia_resultados TO rol_elite_app;

-- Solo lectura en tablas de configuración
GRANT SELECT ON TABLE servicios TO rol_elite_app;
GRANT SELECT ON TABLE instructores TO rol_elite_app;
GRANT SELECT ON TABLE trivia_preguntas TO rol_elite_app;
GRANT SELECT ON TABLE trivia_opciones TO rol_elite_app;

-- Acceso a secuencias (necesario para INSERT con SERIAL)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA academia_elite TO rol_elite_app;

COMMENT ON ROLE rol_elite_app IS 'Rol para la aplicación web con permisos CRUD limitados';

-- ROL 3: AUDITOR (Solo Lectura)
CREATE ROLE rol_elite_auditor;
GRANT CONNECT ON DATABASE postgres TO rol_elite_auditor;
GRANT USAGE ON SCHEMA academia_elite TO rol_elite_auditor;
GRANT SELECT ON ALL TABLES IN SCHEMA academia_elite TO rol_elite_auditor;

COMMENT ON ROLE rol_elite_auditor IS 'Rol de solo lectura para auditoría y análisis';

-- =====================================================
-- 3. CREACIÓN DE USUARIOS
-- =====================================================

-- Usuario para la Aplicación Web
CREATE USER user_app WITH PASSWORD 'app_secure_password_2026_CHANGE_ME';
GRANT rol_elite_app TO user_app;
COMMENT ON ROLE user_app IS 'Usuario de la aplicación web';

-- Usuario para Auditoría
CREATE USER user_auditor WITH PASSWORD 'audit_view_only_2026_CHANGE_ME';
GRANT rol_elite_auditor TO user_auditor;
COMMENT ON ROLE user_auditor IS 'Usuario para auditoría y reportes';

-- Usuario Administrador
CREATE USER admin_master WITH PASSWORD 'master_key_elite_2026_CHANGE_ME';
GRANT rol_elite_admin TO admin_master;
COMMENT ON ROLE admin_master IS 'Usuario administrador con acceso total';

-- =====================================================
-- 4. REVOCACIÓN DE PERMISOS PÚBLICOS
-- =====================================================

-- Revocar todos los permisos del rol PUBLIC
REVOKE ALL ON SCHEMA academia_elite FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA academia_elite FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA academia_elite FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA academia_elite FROM PUBLIC;

-- =====================================================
-- 5. POLÍTICAS DE SEGURIDAD ADICIONALES
-- =====================================================

-- Configurar SSL/TLS (recomendado para producción)
-- ALTER SYSTEM SET ssl = on;
-- ALTER SYSTEM SET ssl_cert_file = '/path/to/server.crt';
-- ALTER SYSTEM SET ssl_key_file = '/path/to/server.key';

-- Configurar límites de conexión
ALTER ROLE user_app CONNECTION LIMIT 50;
ALTER ROLE user_auditor CONNECTION LIMIT 10;
ALTER ROLE admin_master CONNECTION LIMIT 5;

-- Configurar timeout de sesión
ALTER ROLE user_app SET statement_timeout = '30s';
ALTER ROLE user_auditor SET statement_timeout = '60s';

-- =====================================================
-- 6. AUDITORÍA Y LOGGING
-- =====================================================

-- Habilitar logging de conexiones
-- ALTER SYSTEM SET log_connections = on;
-- ALTER SYSTEM SET log_disconnections = on;

-- Logging de sentencias DDL
-- ALTER SYSTEM SET log_statement = 'ddl';

-- =====================================================
-- 7. VERIFICACIÓN DE SEGURIDAD
-- =====================================================

-- Verificar roles creados
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles
WHERE rolname LIKE 'rol_elite_%' OR rolname LIKE '%_app' OR rolname LIKE '%_auditor' OR rolname = 'admin_master';

-- Verificar permisos en tablas
SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE table_schema = 'academia_elite'
ORDER BY grantee, table_name;

-- =====================================================
-- 8. MEJORES PRÁCTICAS DE SEGURIDAD
-- =====================================================

/*
RECOMENDACIONES CRÍTICAS:

1. CONTRASEÑAS:
   - Cambiar INMEDIATAMENTE las contraseñas por defecto
   - Usar contraseñas de al menos 16 caracteres
   - Incluir mayúsculas, minúsculas, números y símbolos
   - Rotar contraseñas cada 90 días

2. CONEXIONES:
   - Usar SSL/TLS en producción
   - Restringir acceso por IP en pg_hba.conf
   - Usar VPN para acceso remoto

3. BACKUPS:
   - Realizar backups diarios automáticos
   - Encriptar backups
   - Almacenar backups en ubicación segura fuera del servidor
   - Probar restauración periódicamente

4. MONITOREO:
   - Activar logging de todas las conexiones
   - Monitorear intentos de acceso fallidos
   - Configurar alertas para actividad sospechosa
   - Revisar logs semanalmente

5. ACTUALIZACIONES:
   - Mantener PostgreSQL actualizado
   - Aplicar parches de seguridad inmediatamente
   - Revisar CVEs periódicamente

6. PRINCIPIO DE MÍNIMO PRIVILEGIO:
   - Otorgar solo los permisos necesarios
   - Revisar permisos trimestralmente
   - Revocar accesos de usuarios inactivos

7. SUPABASE ESPECÍFICO:
   - Habilitar RLS en TODAS las tablas sensibles
   - Usar políticas restrictivas por defecto
   - Nunca exponer la clave de servicio (service_role_key) al frontend
   - Usar solo la clave anónima (anon_key) en el cliente
   - Configurar límites de tasa (rate limiting)
   - Habilitar autenticación de dos factores (2FA) para administradores

8. VALIDACIÓN DE DATOS:
   - Validar SIEMPRE en backend, no solo en frontend
   - Usar prepared statements para prevenir SQL injection
   - Sanitizar entradas de usuario
   - Implementar validación de tipos y rangos

9. GESTIÓN DE SESIONES:
   - Configurar expiración de tokens JWT
   - Invalidar sesiones al cambiar contraseña
   - Implementar logout en todos los dispositivos
   - Monitorear sesiones activas

10. COMPLIANCE:
    - Cumplir con GDPR/LOPD para datos personales
    - Documentar procesamiento de datos
    - Implementar derecho al olvido
    - Mantener registro de accesos a datos sensibles
*/

-- =====================================================
-- 9. CONFIGURACIÓN DE pg_hba.conf (Ejemplo)
-- =====================================================

/*
Agregar al archivo pg_hba.conf:

# Conexiones locales
local   all             admin_master                            scram-sha-256
local   all             user_app                                scram-sha-256

# Conexiones desde la aplicación web (ajustar IP)
host    postgres        user_app        192.168.1.0/24          scram-sha-256

# Conexiones de auditoría (solo desde IPs específicas)
host    postgres        user_auditor    10.0.0.100/32           scram-sha-256

# Denegar todo lo demás
host    all             all             0.0.0.0/0               reject
*/

-- =====================================================
-- 10. SCRIPT DE ROTACIÓN DE CONTRASEÑAS
-- =====================================================

/*
Ejecutar cada 90 días:

ALTER USER user_app WITH PASSWORD 'nueva_contraseña_segura';
ALTER USER user_auditor WITH PASSWORD 'nueva_contraseña_segura';
ALTER USER admin_master WITH PASSWORD 'nueva_contraseña_segura';

Registrar cambio en bitácora de seguridad.
*/

-- =====================================================
-- FIN DE ESTRATEGIA DE SEGURIDAD
-- =====================================================
