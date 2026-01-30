# Plan de Trabajo - Academia Élite
## Guía de Agentes y Próximos Pasos

---

## 📋 Estado Actual del Proyecto

### ✅ Completado
- [x] Dashboard de alumnos con todas las funcionalidades
- [x] Sistema de avatares pixel art (7 avatares)
- [x] Base de datos reorganizada y unificada
- [x] Esquema Supabase listo para implementar
- [x] Datos semilla (instructores, servicios, trivia)
- [x] Seguridad RLS configurada
- [x] Corrección de `acceso-alumnos.html`

### 🔄 En Proceso
- [ ] Implementar esquema en Supabase
- [ ] Probar flujo completo de registro/login
- [ ] Verificar dashboard con datos reales

### 📝 Pendiente
- [ ] Dashboard de instructores
- [ ] Sistema de trivia funcional
- [ ] Página de servicios/cursos
- [ ] Sistema de pagos
- [ ] Reportes y estadísticas

---

## 🎯 Próximos Pasos Inmediatos

### Paso 1: Implementar Base de Datos en Supabase
**Agente:** TÚ (Usuario) - Manual  
**Tiempo:** 5-10 minutos  
**Archivo:** `SUPABASE_SETUP.md`

**Acciones:**
1. Ir a https://app.supabase.com
2. Proyecto: `aldwcqpgsjfjcttxfecp`
3. SQL Editor → Ejecutar `supabase_schema.sql`
4. SQL Editor → Ejecutar `seed_data.sql`
5. Verificar en Table Editor

**Resultado esperado:** 10 tablas creadas con datos iniciales

---

### Paso 2: Probar Registro y Login
**Agente:** TÚ (Usuario) - Manual  
**Tiempo:** 5 minutos  
**Archivo:** `acceso-alumnos.html`

**Acciones:**
1. Abrir `acceso-alumnos.html` en navegador
2. Registrar usuario de prueba
3. Iniciar sesión
4. Verificar que carga `dashboard-alumno.html`

**Resultado esperado:** Login exitoso y dashboard funcional

---

### Paso 3: Completar Dashboard de Instructores
**Agente:** @Antigravity (YO) - Desarrollo Frontend  
**Tiempo:** 30-45 minutos  
**Archivo:** `dashboard-instructor.html`

**Prompt sugerido:**
```
Necesito completar el dashboard de instructores (dashboard-instructor.html).
Debe incluir:
1. Panel de bienvenida con nombre del instructor
2. Lista de clases agendadas (desde reservas_clases)
3. Calendario de disponibilidad
4. Lista de alumnos asignados
5. Estadísticas (clases impartidas, alumnos activos)
6. Estilo consistente con dashboard-alumno.html

Usar Supabase con URL: https://aldwcqpgsjfjcttxfecp.supabase.co
Tabla principal: instructores
Relación: reservas_clases.instructor = instructores.nombre
```

---

### Paso 4: Implementar Sistema de Trivia
**Agente:** @Antigravity (YO) - Desarrollo Frontend + Backend  
**Tiempo:** 45-60 minutos  
**Archivo:** `evaluacion.html` (ya existe)

**Prompt sugerido:**
```
Necesito implementar el sistema de trivia funcional en evaluacion.html.

Funcionalidades:
1. Cargar 10 preguntas aleatorias desde trivia_preguntas
2. Mostrar 4 opciones por pregunta (trivia_opciones)
3. Validar respuestas
4. Calcular puntaje
5. Guardar resultado en trivia_resultados
6. Mostrar nivel alcanzado (PILOTO ÉLITE si >80%, ASPIRANTE si >60%)
7. Actualizar puntaje_trivia en tabla alumnos

Usar Supabase: https://aldwcqpgsjfjcttxfecp.supabase.co
Estilo: Consistente con el diseño élite (dorado #C5A059, negro)
```

---

### Paso 5: Crear Página de Servicios/Cursos
**Agente:** @Antigravity (YO) - Desarrollo Frontend  
**Tiempo:** 30-45 minutos  
**Archivo:** `cursos.html` (ya existe, necesita actualización)

**Prompt sugerido:**
```
Actualizar cursos.html para mostrar el catálogo de servicios desde Supabase.

Funcionalidades:
1. Cargar servicios activos desde tabla servicios
2. Mostrar tarjetas con: nombre, descripción, precio, duración, categoría
3. Filtros por: categoría de licencia, nivel de dificultad
4. Botón "Matricularme" (solo para usuarios autenticados)
5. Diseño tipo catálogo premium con efecto glassmorphism

Usar Supabase: https://aldwcqpgsjfjcttxfecp.supabase.co
Paleta: Dorado #C5A059, Negro #0a0a0a, Rojo #b71c1c
```

---

### Paso 6: Sistema de Matrículas
**Agente:** @Antigravity (YO) - Desarrollo Full Stack  
**Tiempo:** 60-90 minutos  
**Archivo:** Nuevo archivo `matriculas.html`

**Prompt sugerido:**
```
Crear sistema de matrículas para Academia Élite.

Funcionalidades:
1. Formulario de matrícula:
   - Seleccionar servicio (desde tabla servicios)
   - Fecha de inicio deseada
   - Método de pago (EFECTIVO, TARJETA, TRANSFERENCIA)
2. Crear registro en tabla matriculas
3. Crear registro en tabla pagos
4. Enviar confirmación
5. Mostrar mis matrículas activas en dashboard

Validaciones:
- Usuario debe estar autenticado
- Verificar que no tenga matrícula activa del mismo curso
- Validar datos antes de insertar

Usar Supabase: https://aldwcqpgsjfjcttxfecp.supabase.co
```

---

### Paso 7: Reportes y Estadísticas (Admin)
**Agente:** @Antigravity (YO) - Desarrollo Frontend + Analytics  
**Tiempo:** 60-90 minutos  
**Archivo:** Nuevo archivo `admin-dashboard.html`

**Prompt sugerido:**
```
Crear dashboard administrativo para Academia Élite.

Funcionalidades:
1. Estadísticas generales:
   - Total de alumnos registrados
   - Total de matrículas activas
   - Ingresos del mes
   - Clases programadas
2. Gráficos:
   - Alumnos por categoría (pie chart)
   - Matrículas por mes (line chart)
   - Servicios más populares (bar chart)
3. Tablas:
   - Últimos registros
   - Próximas clases
   - Pagos pendientes

Usar Supabase: https://aldwcqpgsjfjcttxfecp.supabase.co
Librería de gráficos: Chart.js
Acceso: Solo para usuarios con rol admin
```

---

## 🔧 Tareas de Mantenimiento

### Optimización de Rendimiento
**Agente:** @Antigravity (YO) - Optimización  
**Cuándo:** Después de completar funcionalidades principales

**Prompt sugerido:**
```
Optimizar el rendimiento de Academia Élite:
1. Minificar CSS y JavaScript
2. Lazy loading de imágenes
3. Caché de consultas frecuentes
4. Optimizar queries de Supabase
5. Implementar paginación en listas largas
```

---

### Testing y QA
**Agente:** @Antigravity (YO) - Testing  
**Cuándo:** Antes de producción

**Prompt sugerido:**
```
Realizar testing completo de Academia Élite:
1. Probar flujo de registro/login
2. Probar todas las funcionalidades del dashboard
3. Verificar RLS policies
4. Probar en diferentes navegadores
5. Probar en móvil (responsive)
6. Verificar manejo de errores
7. Probar carga con datos reales
```

---

### Despliegue a Producción
**Agente:** @Antigravity (YO) - DevOps  
**Cuándo:** Cuando todo esté probado

**Prompt sugerido:**
```
Desplegar Academia Élite a producción:
1. Configurar dominio personalizado
2. Configurar SSL/HTTPS
3. Configurar Supabase para producción
4. Configurar variables de entorno
5. Optimizar assets
6. Configurar CDN (opcional)
7. Configurar backups automáticos
```

---

## 📊 Priorización de Tareas

### 🔴 Prioridad ALTA (Hacer Ahora)
1. ✅ Implementar base de datos en Supabase
2. ✅ Probar registro/login
3. 🔄 Dashboard de instructores
4. 🔄 Sistema de trivia funcional

### 🟡 Prioridad MEDIA (Próxima Semana)
5. Página de servicios/cursos
6. Sistema de matrículas
7. Testing completo

### 🟢 Prioridad BAJA (Futuro)
8. Dashboard administrativo
9. Reportes avanzados
10. Optimizaciones
11. Despliegue a producción

---

## 🎯 Cómo Trabajar con Antigravity

### Formato de Prompt Efectivo

```
@Antigravity [Tarea específica]

Contexto:
- Proyecto: Academia de Conducción Élite
- Base de datos: Supabase (https://aldwcqpgsjfjcttxfecp.supabase.co)
- Estilo: Luxury dark mode (dorado #C5A059, negro #0a0a0a)

Objetivo:
[Descripción clara de lo que necesitas]

Requisitos:
1. [Requisito 1]
2. [Requisito 2]
3. [Requisito 3]

Archivos involucrados:
- [archivo1.html]
- [archivo2.js]

Referencia:
- Seguir el estilo de dashboard-alumno.html
- Usar las mismas tablas de Supabase
```

### Ejemplo Práctico

```
@Antigravity Implementar dashboard de instructores

Contexto:
- Proyecto: Academia de Conducción Élite
- Base de datos: Supabase (https://aldwcqpgsjfjcttxfecp.supabase.co)
- Archivo existente: dashboard-instructor.html (necesita actualización)

Objetivo:
Completar el dashboard para que los instructores puedan ver sus clases
agendadas y gestionar su calendario.

Requisitos:
1. Panel de bienvenida con nombre del instructor
2. Lista de clases del día (desde reservas_clases)
3. Calendario semanal con disponibilidad
4. Lista de alumnos asignados
5. Estadísticas: clases impartidas este mes

Archivos involucrados:
- dashboard-instructor.html
- css/dashboard.css (reutilizar estilos)

Referencia:
- Seguir el mismo diseño de dashboard-alumno.html
- Usar tabla instructores y reservas_clases
- Filtrar reservas por instructor.nombre
```

---

## 📁 Estructura de Archivos Actual

```
academia-app/
├── Academia_Elite/
│   ├── index.html                    ✅ Completo
│   ├── acceso-alumnos.html          ✅ Corregido
│   ├── acceso-instructores.html     ✅ Completo
│   ├── dashboard-alumno.html        ✅ Completo
│   ├── dashboard-instructor.html    🔄 Necesita actualización
│   ├── evaluacion.html              🔄 Necesita implementación
│   ├── cursos.html                  🔄 Necesita actualización
│   ├── contacto.html                ✅ Completo
│   ├── nosotros.html                ✅ Completo
│   │
│   ├── css/
│   │   ├── dashboard.css            ✅ Completo
│   │   ├── variables.css            ✅ Completo
│   │   ├── layout.css               ✅ Completo
│   │   └── ...
│   │
│   └── js/
│       └── app.js                   ✅ Completo
│
└── project/
    └── database/
        ├── supabase_schema.sql      ✅ Listo para ejecutar
        ├── seed_data.sql            ✅ Listo para ejecutar
        ├── SUPABASE_SETUP.md        ✅ Guía completa
        └── ...
```

---

## 🚀 Plan de Acción Inmediato

### Hoy (28 Enero 2026)
1. ✅ Ejecutar `supabase_schema.sql` en Supabase
2. ✅ Ejecutar `seed_data.sql` en Supabase
3. ✅ Probar registro de usuario
4. ✅ Probar login y dashboard

### Mañana (29 Enero 2026)
5. 🔄 Completar dashboard de instructores
6. 🔄 Implementar sistema de trivia

### Esta Semana
7. Actualizar página de cursos
8. Implementar sistema de matrículas
9. Testing completo

---

## 📞 Contacto con Antigravity

**Para cada tarea nueva, usa este formato:**

```
@Antigravity [nombre de la tarea]

[Descripción detallada]
[Requisitos específicos]
[Archivos involucrados]
[Referencias de diseño]
```

**Recuerda siempre mencionar:**
- URL de Supabase: `https://aldwcqpgsjfjcttxfecp.supabase.co`
- Paleta de colores: Dorado #C5A059, Negro #0a0a0a, Rojo #b71c1c
- Referencia de diseño: dashboard-alumno.html

---

## ✅ Checklist de Progreso

### Base de Datos
- [ ] Esquema ejecutado en Supabase
- [ ] Datos semilla cargados
- [ ] RLS verificado
- [ ] Tablas verificadas

### Frontend
- [x] Dashboard de alumnos
- [ ] Dashboard de instructores
- [ ] Sistema de trivia
- [ ] Página de cursos
- [ ] Sistema de matrículas

### Testing
- [ ] Registro de usuarios
- [ ] Login/Logout
- [ ] Reserva de clases
- [ ] Actualización de perfil
- [ ] Trivia completa

### Producción
- [ ] Dominio configurado
- [ ] SSL habilitado
- [ ] Backups configurados
- [ ] Monitoreo activo

---

**🎯 Siguiente Acción Recomendada:**

Ejecutar la base de datos en Supabase siguiendo `SUPABASE_SETUP.md`

¿Necesitas ayuda con algún paso específico?
