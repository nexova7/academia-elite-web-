# Guía de Migración de Base de Datos
## Academia de Conducción Élite - v2.0

---

## 📋 Resumen Ejecutivo

Esta guía documenta el proceso de migración desde los esquemas fragmentados existentes hacia el **esquema unificado v2.0**. El nuevo esquema consolida todas las tablas necesarias para el funcionamiento completo del sistema.

---

## 🎯 Objetivos de la Migración

1. **Unificar esquemas fragmentados** en un solo archivo coherente
2. **Agregar tablas faltantes** (`alumnos`, `reservas_clases`, `instructores`)
3. **Implementar seguridad robusta** con RLS y RBAC
4. **Optimizar rendimiento** con índices apropiados
5. **Establecer integridad referencial** completa

---

## 📊 Estado Actual vs Estado Objetivo

### Archivos Antiguos (A Archivar)

| Archivo | Tablas | Estado |
|---------|--------|--------|
| `final_schema_pgadmin.sql` | leads, servicios, trivia_resultados, leads_reservas | ❌ Incompleto |
| `schema.sql` | leads, services, trivia_questions, orders, payments | ❌ Incompleto |
| `init_schema.sql` | leads, servicios, trivia_preguntas | ❌ Incompleto |
| `security_roles.sql` | Roles RBAC | ⚠️ Desactualizado |

### Archivos Nuevos (Usar Estos)

| Archivo | Contenido | Estado |
|---------|-----------|--------|
| `unified_schema.sql` | 10 tablas completas + RLS + triggers | ✅ Completo |
| `seed_data.sql` | Datos iniciales | ✅ Listo |
| `security_strategy.sql` | RBAC + mejores prácticas | ✅ Completo |

---

## 🗂️ Estructura del Nuevo Esquema

### Tablas Principales

```
academia_elite/
├── USUARIOS Y AUTENTICACIÓN
│   ├── alumnos (estudiantes)
│   ├── instructores (profesores)
│   └── leads (potenciales clientes)
│
├── ACADÉMICO
│   ├── servicios (catálogo de cursos)
│   ├── reservas_clases (agendamiento)
│   └── matriculas (inscripciones)
│
├── TRIVIA
│   ├── trivia_preguntas
│   ├── trivia_opciones
│   └── trivia_resultados
│
└── NEGOCIO
    └── pagos (transacciones)
```

---

## 🚀 Proceso de Migración

### Opción A: Instalación Limpia (Recomendado para Desarrollo)

**Cuándo usar:** Base de datos nueva o entorno de desarrollo

```bash
# 1. Conectar a la base de datos
psql -U postgres -d academia_db

# 2. Ejecutar esquema unificado
\i unified_schema.sql

# 3. Cargar datos semilla
\i seed_data.sql

# 4. Aplicar seguridad (PostgreSQL local)
\i security_strategy.sql

# 5. Verificar
\dt academia_elite.*
```

### Opción B: Migración con Datos Existentes (Producción)

**Cuándo usar:** Ya tienes datos en tablas antiguas

#### Paso 1: Backup Completo

```bash
# Backup de toda la base de datos
pg_dump -U postgres -d academia_db -F c -f backup_pre_migration_$(date +%Y%m%d).dump

# Backup solo del esquema academia_elite
pg_dump -U postgres -d academia_db -n academia_elite -F c -f backup_schema_$(date +%Y%m%d).dump
```

#### Paso 2: Exportar Datos Existentes

```sql
-- Exportar leads existentes
COPY academia_elite.leads TO '/tmp/leads_backup.csv' CSV HEADER;

-- Exportar servicios existentes
COPY academia_elite.servicios TO '/tmp/servicios_backup.csv' CSV HEADER;

-- Exportar resultados de trivia
COPY academia_elite.trivia_resultados TO '/tmp/trivia_backup.csv' CSV HEADER;
```

#### Paso 3: Crear Nuevo Esquema

```sql
-- Renombrar esquema antiguo (por seguridad)
ALTER SCHEMA academia_elite RENAME TO academia_elite_old;

-- Ejecutar nuevo esquema
\i unified_schema.sql
```

#### Paso 4: Migrar Datos

```sql
-- Migrar leads (si existen)
INSERT INTO academia_elite.leads (nombre_completo, email, telefono, origen)
SELECT nombre_completo, email, telefono, 'WEB'
FROM academia_elite_old.leads
ON CONFLICT (email) DO NOTHING;

-- Migrar servicios (si existen)
INSERT INTO academia_elite.servicios (nombre_curso, descripcion, precio, categoria_licencia, duracion_horas, nivel_dificultad)
SELECT nombre_curso, descripcion, precio, 'B1', duracion_horas, nivel_dificultad
FROM academia_elite_old.servicios
ON CONFLICT DO NOTHING;

-- Cargar datos semilla adicionales
\i seed_data.sql
```

#### Paso 5: Verificación

```sql
-- Verificar conteo de registros
SELECT 'leads' as tabla, COUNT(*) FROM academia_elite.leads
UNION ALL
SELECT 'servicios', COUNT(*) FROM academia_elite.servicios
UNION ALL
SELECT 'instructores', COUNT(*) FROM academia_elite.instructores;

-- Verificar integridad referencial
SELECT conname, conrelid::regclass, confrelid::regclass
FROM pg_constraint
WHERE contype = 'f' AND connamespace = 'academia_elite'::regnamespace;
```

#### Paso 6: Aplicar Seguridad

```sql
\i security_strategy.sql
```

---

## 🔐 Migración en Supabase

### Paso 1: Acceder al SQL Editor

1. Ir a [Supabase Dashboard](https://app.supabase.com)
2. Seleccionar proyecto: `aldwcqpgsjfjcttxfecp`
3. Ir a **SQL Editor**

### Paso 2: Ejecutar Esquema

```sql
-- Copiar y pegar el contenido completo de unified_schema.sql
-- Ejecutar
```

### Paso 3: Cargar Datos Semilla

```sql
-- Copiar y pegar el contenido de seed_data.sql
-- Ejecutar
```

### Paso 4: Verificar RLS

```sql
-- Verificar que RLS está habilitado
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('alumnos', 'reservas_clases', 'matriculas', 'pagos');

-- Verificar políticas
SELECT schemaname, tablename, policyname, permissive, roles, cmd
FROM pg_policies
WHERE schemaname = 'public';
```

### Paso 5: Configurar Autenticación

1. Ir a **Authentication** > **Providers**
2. Habilitar **Email** provider
3. Configurar **Email Templates** (opcional)
4. Configurar **URL Configuration**:
   - Site URL: `https://tu-dominio.com`
   - Redirect URLs: Agregar URLs permitidas

---

## 🧪 Testing Post-Migración

### Test 1: Registro de Alumno

```javascript
// En acceso-alumnos.html
const { data, error } = await supabase.auth.signUp({
  email: 'test@academiaelite.com',
  password: 'TestPassword123!'
});

// Verificar que se creó el registro en alumnos
const { data: alumno } = await supabase
  .from('alumnos')
  .select('*')
  .eq('email', 'test@academiaelite.com');

console.log(alumno);
```

### Test 2: Reserva de Clase

```javascript
// En dashboard-alumno.html
const { data, error } = await supabase
  .from('reservas_clases')
  .insert([{
    alumno_id: currentUserId,
    instructor: 'Instructora Liliana',
    fecha: '2026-02-15',
    hora: '10:00'
  }]);

console.log(data, error);
```

### Test 3: Consulta de Servicios

```javascript
const { data: servicios } = await supabase
  .from('servicios')
  .select('*')
  .eq('activo', true);

console.log(servicios);
```

---

## 📁 Organización de Archivos

### Estructura Recomendada

```
project/database/
├── unified_schema.sql          ← USAR ESTE
├── seed_data.sql               ← USAR ESTE
├── security_strategy.sql       ← USAR ESTE
├── migration_guide.md          ← ESTE DOCUMENTO
│
└── archive/                    ← MOVER AQUÍ LOS ANTIGUOS
    ├── final_schema_pgadmin.sql
    ├── schema.sql
    ├── init_schema.sql
    └── security_roles.sql
```

---

## ⚠️ Problemas Comunes y Soluciones

### Problema 1: Error de Permisos en Supabase

**Error:** `permission denied for table alumnos`

**Solución:**
```sql
-- Verificar que RLS está configurado correctamente
ALTER TABLE alumnos ENABLE ROW LEVEL SECURITY;

-- Recrear políticas
DROP POLICY IF EXISTS "Alumnos pueden ver su propio perfil" ON alumnos;
CREATE POLICY "Alumnos pueden ver su propio perfil"
    ON alumnos FOR SELECT
    USING (auth.uid() = id);
```

### Problema 2: Tabla `auth.users` No Existe

**Contexto:** Solo aplica en PostgreSQL local, no en Supabase

**Solución:**
```sql
-- Cambiar la definición de alumnos
ALTER TABLE alumnos DROP CONSTRAINT IF EXISTS alumnos_id_fkey;

-- Usar UUID simple sin FK a auth.users
ALTER TABLE alumnos ALTER COLUMN id SET DEFAULT gen_random_uuid();
```

### Problema 3: Conflicto de Nombres de Columnas

**Error:** `column "nombre_completo" does not exist`

**Contexto:** El dashboard usa `nombre`, pero el registro usa `nombre_completo`

**Solución:**
```sql
-- Opción 1: Agregar alias en consultas
SELECT nombre as nombre_completo FROM alumnos;

-- Opción 2: Agregar columna adicional
ALTER TABLE alumnos ADD COLUMN nombre_completo VARCHAR(150);
UPDATE alumnos SET nombre_completo = nombre;
```

### Problema 4: Domingos en Reservas

**Error:** `new row violates check constraint "no_domingos"`

**Solución:** Validar en frontend antes de enviar
```javascript
const dia = new Date(fecha).getUTCDay();
if (dia === 0) {
  alert("No se permiten reservas los domingos");
  return;
}
```

---

## 📊 Checklist de Migración

### Pre-Migración
- [ ] Backup completo de la base de datos
- [ ] Exportar datos existentes a CSV
- [ ] Documentar configuración actual
- [ ] Notificar a usuarios de mantenimiento

### Durante Migración
- [ ] Ejecutar `unified_schema.sql`
- [ ] Cargar `seed_data.sql`
- [ ] Migrar datos existentes (si aplica)
- [ ] Aplicar `security_strategy.sql`
- [ ] Verificar integridad referencial

### Post-Migración
- [ ] Ejecutar tests de funcionalidad
- [ ] Verificar RLS policies
- [ ] Probar registro de usuario
- [ ] Probar reserva de clases
- [ ] Verificar dashboard
- [ ] Monitorear logs por 24 horas

### Limpieza
- [ ] Archivar esquemas antiguos
- [ ] Actualizar documentación
- [ ] Eliminar esquema antiguo (después de 30 días)
- [ ] Actualizar scripts de backup

---

## 🆘 Rollback Plan

Si algo sale mal durante la migración:

```sql
-- 1. Detener la aplicación

-- 2. Restaurar desde backup
pg_restore -U postgres -d academia_db -c backup_pre_migration_YYYYMMDD.dump

-- 3. Verificar restauración
SELECT COUNT(*) FROM academia_elite.leads;

-- 4. Reiniciar aplicación

-- 5. Investigar causa del fallo
```

---

## 📞 Soporte

Si encuentras problemas durante la migración:

1. Revisar logs de PostgreSQL: `/var/log/postgresql/`
2. Consultar documentación de Supabase: https://supabase.com/docs
3. Verificar este documento
4. Contactar al equipo de desarrollo

---

## 📝 Registro de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2026-01-28 | 2.0 | Esquema unificado inicial |

---

**✅ Migración Completa - Academia Élite v2.0**
