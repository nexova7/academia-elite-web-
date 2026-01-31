# 🏗️ Blueprint: Dashboard de Instructores V2 (Elite Drive)

## 🎯 Objetivo General
Transformar el panel de instructores en una interfaz de "Cristal de Alta Tecnología", con doble columna para gestión simultánea de los instructores principales (Liliana y Camilo), conectada en tiempo real a Supabase.

## 1. 📐 Arquitectura Visual (UI)

### 1.1 Estructura de Pantalla Dividida
El área principal (`#agenda`) se transformará en un **Grid de 2 Columnas** (Desktop) o **Columna Única Apilable** (Mobile).

-   **Panel Izquierdo (Liliana)**:
    -   Estilo: `Glassmorphism` (Fondo semitransparente + Blur).
    -   Borde: `2px solid #c5a059` (Dorado Élite).
    -   Título: "Instructora Liliana" (Dorado).
-   **Panel Derecho (Camilo)**:
    -   Estilo: `Glassmorphism`.
    -   Borde: `2px solid #silver` (Plata/Azul Metálico).
    -   Título: "Instructor Camilo" (Plata).
-   **Header Semanal**: Barra superior que muestra "Semana del [Fecha Inicio] al [Fecha Fin]".
    -   *Lógica Domingo*: Si es domingo, la vista se resetea automáticamente a la semana siguiente.

### 1.2 Tarjetas de Clase (Cells)
Cada reserva se renderiza como una "Burbuja de Cristal":
-   **Icono Visual**: 🚗 (Carro) o 🏍️ (Moto) según la categoría del alumno.
-   **Datos**: Hora, Nombre Alumno.
-   **Etiqueta Nivel**: Badge sutil (Básico, Intermedio, Examen).
-   **Estado**:
    -   Confirmada: Borde neutro/blanco.
    -   Cancelada (Alumno): Fondo rojo suave semitransparente.
    -   Completada: Opacidad reducida.

## 2. 🧭 Navegación & UX

### 2.1 Menú "Glass"
-   **Móvil**: Botón hamburguesa flotante con efecto blur. Panel lateral deslizante (Off-canvas).
-   **Desktop**: Sidebar lateral fija con estética minimalista.
-   **Cerrar Sesión**: Botón en esquina superior derecha.
    -   Acción: `supabase.auth.signOut()` + Redirección a `index.html`.

### 2.2 Botones Intercambiables
-   **Estilo General**: `backdrop-filter: blur(15px)`, `border-radius: 50px`.
-   **Hover Effect**: Brillo interior (`box-shadow: inset 0 0 10px rgba(255,255,255,0.2)`).

## 3. 🛠️ Módulo de Gestión (Alumnos)

### 3.1 Buscador Inteligente
-   Input `text` con evento `keyup`.
-   Filtro en tiempo real sobre la lista de alumnos cargada desde Supabase.

### 3.2 Acciones Rápidas (Seguridad)
-   **Reset Password**: Botón "Cristal Ámbar".
    -   Acción: `supabase.auth.updateUser` (Admin API) - *Nota: Requiere Service Role o Function. Como workaround seguro desde cliente: Enviar email de recuperación o marcar flag "reset_required"*.
    -   *Solución Implementación*: Botón que copia una "Clave Temporal" (ELITE2026) al portapapeles y permite al instructor actualizarla si tiene permisos, o envía un reset mail.

### 3.3 Indicadores
-   🟢 Activo
-   🟡 Pausa
-   🏆 Certificado (Dorado)

## 4. 💬 Control & Feedback

### 4.1 Cancelaciones
-   **Botón "X"**: Elemento flotante en la tarjeta de clase.
-   **Lógica**:
    -   Instructor cancela: `UPDATE reservas_clases SET estado = 'CANCELADA_INSTRUCTOR'`. Libera horario.
    -   Alumno cancela (Visual): La tarjeta ya viene con estado `CANCELADA` desde la DB, se muestra en rojo.

### 4.2 Notas
-   Textarea integrado en el modal de detalle de la clase.
-   Botón "Guardar Nota": `INSERT/UPDATE` en tabla `notas_progreso` o campo `notas` de la reserva.

## 5. 💻 Stack Tecnológico
-   **Frontend**: HTML5, CSS3 (Variables, Flexbox, Grid), Vanilla JS.
-   **Backend**: Supabase (Lectura de tablas `reservas_clases`, `alumnos`).
-   **Seguridad**: `js/supabase-config.js` (Cliente Anon).

## 📋 Plan de Ejecución
1.  **CSS Update**: Implementar clases `.glass-panel`, `.col-liliana`, `.col-camilo`, `.glass-btn`.
2.  **HTML Refactor**: Dividir `#agenda` en dos contenedores.
3.  **JS Logic**:
    -   Conectar con `window.supabaseInstance`.
    -   Función `fetchWeeklySchedule()`: Traer reservas de la semana.
    -   Función `renderColumn(instructor, data)`.
    -   Función `handleSundayReset()`.

---
*Autor: Agente Antigravity*
*Fecha: 2026-01-30*
