# Guía de Configuración en Supabase
## Academia de Conducción Élite

**URL del Proyecto:** https://aldwcqpgsjfjcttxfecp.supabase.co

---

## 🎯 Pasos para Configurar la Base de Datos

### Paso 1: Acceder a Supabase Dashboard

1. Ir a: https://app.supabase.com
2. Iniciar sesión con tu cuenta
3. Seleccionar el proyecto: `aldwcqpgsjfjcttxfecp`

---

### Paso 2: Abrir SQL Editor

1. En el menú lateral izquierdo, clic en **SQL Editor**
2. Clic en **New query** (botón verde)

---

### Paso 3: Ejecutar el Esquema Principal

1. Abrir el archivo: `supabase_schema.sql`
2. **Copiar TODO el contenido** del archivo
3. **Pegar** en el SQL Editor de Supabase
4. Clic en **Run** (botón verde abajo a la derecha)
5. Esperar confirmación: "Success. No rows returned"

**Tiempo estimado:** 10-15 segundos

---

### Paso 4: Cargar Datos Semilla

1. Clic en **New query** nuevamente
2. Abrir el archivo: `seed_data.sql`
3. **Copiar TODO el contenido**
4. **Pegar** en el SQL Editor
5. Clic en **Run**
6. Esperar confirmación

**Datos cargados:**
- ✅ 4 instructores
- ✅ 8 servicios/cursos
- ✅ 10 preguntas de trivia
- ✅ 40 opciones de respuesta

---

### Paso 5: Verificar Tablas Creadas

1. En el menú lateral, clic en **Table Editor**
2. Deberías ver estas 10 tablas:
   - ✅ alumnos
   - ✅ instructores
   - ✅ leads
   - ✅ servicios
   - ✅ reservas_clases
   - ✅ matriculas
   - ✅ trivia_preguntas
   - ✅ trivia_opciones
   - ✅ trivia_resultados
   - ✅ pagos

3. Clic en cada tabla para verificar su estructura

---

### Paso 6: Verificar Row Level Security (RLS)

1. Ir a **Authentication** > **Policies**
2. Deberías ver políticas para:
   - alumnos (3 políticas)
   - reservas_clases (4 políticas)
   - matriculas (1 política)
   - pagos (1 política)
   - servicios (2 políticas)
   - instructores (1 política)
   - trivia_preguntas (1 política)
   - trivia_opciones (1 política)

**Total esperado:** ~14 políticas activas

---

### Paso 7: Configurar Autenticación

1. Ir a **Authentication** > **Providers**
2. Verificar que **Email** esté habilitado ✅
3. Ir a **Authentication** > **URL Configuration**
4. Configurar:
   - **Site URL:** `https://tu-dominio.com` (o `http://localhost` para desarrollo)
   - **Redirect URLs:** Agregar las URLs de tu aplicación

---

### Paso 8: Obtener Credenciales

1. Ir a **Settings** > **API**
2. Copiar:
   - **Project URL:** `https://aldwcqpgsjfjcttxfecp.supabase.co`
   - **anon public key:** (ya lo tienes: `sb_publishable_OvQYw50Cs8sM21AJGg21zg_v3LunT3J`)

**⚠️ IMPORTANTE:** 
- **NUNCA** uses la `service_role` key en el frontend
- Solo usa la `anon` key en el cliente

---

## 🧪 Probar la Configuración

### Test 1: Verificar Datos Semilla

En SQL Editor, ejecutar:

```sql
-- Ver instructores
SELECT * FROM public.instructores;

-- Ver servicios
SELECT * FROM public.servicios;

-- Ver preguntas de trivia
SELECT * FROM public.trivia_preguntas;

-- Contar registros
SELECT 
    'instructores' as tabla, COUNT(*) as total FROM public.instructores
UNION ALL
SELECT 'servicios', COUNT(*) FROM public.servicios
UNION ALL
SELECT 'trivia_preguntas', COUNT(*) FROM public.trivia_preguntas
UNION ALL
SELECT 'trivia_opciones', COUNT(*) FROM public.trivia_opciones;
```

**Resultado esperado:**
```
instructores      | 4
servicios         | 8
trivia_preguntas  | 10
trivia_opciones   | 40
```

---

### Test 2: Verificar RLS

En SQL Editor, ejecutar:

```sql
-- Ver políticas activas
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
```

Deberías ver todas las políticas listadas.

---

### Test 3: Probar Registro de Usuario

1. Abrir: `C:\Users\visitante\Desktop\academia-app\Academia_Elite\acceso-alumnos.html`
2. Ir a la pestaña **Registro Estudiante**
3. Llenar el formulario:
   - Nombre de Usuario: `test_user`
   - Nombre Completo: `Usuario de Prueba`
   - Correo: `test@academiaelite.com`
   - Categoría: `B1`
   - Contraseña: `Test123456`
   - Repetir Contraseña: `Test123456`
4. Clic en **1. SOLICITAR PIN AL WHATSAPP**
5. Usar PIN de prueba: `A123`
6. Clic en **2. INGRESAR PIN Y FINALIZAR**

**Resultado esperado:** "✅ Registro exitoso. ¡Bienvenido!"

---

### Test 4: Verificar Usuario en Supabase

1. Ir a **Authentication** > **Users**
2. Deberías ver el usuario recién creado
3. Ir a **Table Editor** > **alumnos**
4. Deberías ver el registro del alumno

---

### Test 5: Probar Dashboard

1. Iniciar sesión con el usuario de prueba
2. Deberías ser redirigido a `dashboard-alumno.html`
3. Verificar que se muestre:
   - ✅ Nombre del alumno en el banner de bienvenida
   - ✅ Categoría (B1)
   - ✅ Estadísticas (inicialmente en 0)
   - ✅ Perfil con datos cargados

---

## 🔧 Solución de Problemas Comunes

### Problema 1: Error "permission denied for table alumnos"

**Causa:** RLS no está configurado correctamente

**Solución:**
```sql
-- Verificar que RLS esté habilitado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'alumnos';

-- Si rowsecurity = false, ejecutar:
ALTER TABLE public.alumnos ENABLE ROW LEVEL SECURITY;

-- Recrear políticas (ejecutar supabase_schema.sql nuevamente)
```

---

### Problema 2: No se pueden insertar alumnos

**Causa:** Falta la política de INSERT

**Solución:**
```sql
-- Verificar políticas de INSERT
SELECT * FROM pg_policies 
WHERE tablename = 'alumnos' 
AND cmd = 'INSERT';

-- Si no existe, crear:
CREATE POLICY "Permitir inserción de nuevos alumnos"
    ON public.alumnos FOR INSERT
    WITH CHECK (auth.uid() = id);
```

---

### Problema 3: Error en acceso-alumnos.html (línea 156)

**Error:** `column "nombre_completo" does not exist`

**Solución:** Editar `acceso-alumnos.html` línea 154-159:

**Cambiar:**
```javascript
await _supabase.from('alumnos').insert([{ 
    id: data.user.id, 
    nombre_completo: full,  // ❌ INCORRECTO
    email: email,
    categoria: document.getElementById('regCat').value
}]);
```

**Por:**
```javascript
await _supabase.from('alumnos').insert([{ 
    id: data.user.id, 
    nombre: full,  // ✅ CORRECTO
    email: email,
    categoria: document.getElementById('regCat').value
}]);
```

---

### Problema 4: Trivia no carga preguntas

**Causa:** Políticas RLS bloqueando acceso anónimo

**Solución:**
```sql
-- Verificar política para anónimos
SELECT * FROM pg_policies 
WHERE tablename = 'trivia_preguntas';

-- Asegurar que existe política para 'anon'
CREATE POLICY "Preguntas activas visibles para todos"
    ON public.trivia_preguntas FOR SELECT
    TO anon, authenticated
    USING (activa = TRUE);
```

---

## 📊 Verificación Final

### Checklist de Configuración

- [ ] Esquema ejecutado sin errores
- [ ] 10 tablas creadas en Table Editor
- [ ] Datos semilla cargados (4 instructores, 8 servicios, 10 preguntas)
- [ ] ~14 políticas RLS activas
- [ ] Email authentication habilitado
- [ ] URL configuration configurada
- [ ] Credenciales API copiadas
- [ ] Test de registro exitoso
- [ ] Test de login exitoso
- [ ] Dashboard carga correctamente
- [ ] Archivo acceso-alumnos.html corregido (línea 156)

---

## 🔐 Seguridad - Mejores Prácticas

### ✅ Hacer

1. **Usar solo anon key en frontend**
   ```javascript
   const SUPABASE_ANON_KEY = 'sb_publishable_OvQYw50Cs8sM21AJGg21zg_v3LunT3J';
   ```

2. **Habilitar RLS en todas las tablas sensibles**
   - ✅ Ya está configurado en el esquema

3. **Validar datos en frontend Y backend**
   - Frontend: JavaScript en formularios
   - Backend: CHECK constraints en SQL

4. **Usar políticas restrictivas por defecto**
   - ✅ Ya implementadas

5. **Monitorear logs de autenticación**
   - Ir a **Logs** > **Auth Logs** regularmente

### ❌ NO Hacer

1. **NUNCA exponer service_role key**
   - No incluir en código frontend
   - No commitear en Git

2. **No deshabilitar RLS**
   - Mantener siempre habilitado

3. **No usar SELECT * en producción**
   - Especificar columnas necesarias

4. **No almacenar contraseñas en texto plano**
   - Supabase Auth las hashea automáticamente

---

## 📞 Recursos Adicionales

### Documentación Oficial
- Supabase Docs: https://supabase.com/docs
- Row Level Security: https://supabase.com/docs/guides/auth/row-level-security
- Auth Helpers: https://supabase.com/docs/guides/auth

### Archivos del Proyecto
- `supabase_schema.sql` - Esquema principal
- `seed_data.sql` - Datos iniciales
- `migration_guide.md` - Guía de migración
- `walkthrough.md` - Documentación completa

### Comandos SQL Útiles

```sql
-- Ver todas las tablas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Ver estructura de una tabla
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'alumnos'
ORDER BY ordinal_position;

-- Ver políticas RLS
SELECT * FROM pg_policies WHERE schemaname = 'public';

-- Ver índices
SELECT indexname, tablename 
FROM pg_indexes 
WHERE schemaname = 'public';

-- Contar usuarios registrados
SELECT COUNT(*) FROM auth.users;

-- Ver alumnos registrados
SELECT id, nombre, email, categoria, fecha_registro 
FROM public.alumnos 
ORDER BY fecha_registro DESC;
```

---

## ✅ Configuración Completada

Una vez que hayas completado todos los pasos y verificaciones, tu base de datos en Supabase estará lista para producción.

**Próximo paso:** Corregir `acceso-alumnos.html` y probar el flujo completo de registro → login → dashboard.

---

**🎉 ¡Base de Datos Configurada en Supabase! 🎉**

Proyecto: https://aldwcqpgsjfjcttxfecp.supabase.co
