# Academia de Conducción Élite - Proyecto Digital

**Versión**: 1.0.0
**Estado**: Estable / Demo

## Descripción
Plataforma web premium para la **Academia de Conducción Élite**, diseñada bajo estándares estrictos de estética (Lujo/Modo Oscuro) y arquitectura de software. Incluye un landing page SPA y un módulo interactivo de evaluación de conductores (Trivia).

## Características Principales
*   **Diseño 'Prestige'**: Sistema de diseño personalizado con paleta *Rich Black*, *Elite Red* y *Prestige Gold*.
*   **Arquitectura Limpia**: Separación estricta de responsabilidades (Frontend desacoplado, Datos mockeados, Estilos por capas).
*   **Módulo Trivia**: Gamificación para captación de leads con feedback inmediato.
*   **Performance**: Cero dependencias externas pesadas (Vanilla JS/CSS).

## Estructura del Proyecto
El proyecto sigue una normativa de directorios estricta:

```text
/project
 ├── docs/          # Documentación (Auditorías, Diseño)
 ├── design/        # UI Kit y Wireframes
 ├── database/      # Esquemas SQL y JSON Data
 ├── frontend/      # Código Fuente Web
 │   ├── css/       # Variables, Base, Components, Layout
 │   ├── js/        # Lógica de Aplicación
 │   └── data/      # Assets locales
```

## Instrucciones de Ejecución
1.  **Requisitos**: Navegador Web Moderno (Chrome/Edge/Firefox).
2.  **Instalar**: No requiere instalación (Vanilla Tech).
3.  **Ejecutar**:
    *   Abrir el archivo `project/frontend/index.html` en su navegador.
    *   Navegar por la sección "Inicio" y probar el botón "Iniciar Evaluación".

## Tecnologías
*   **HTML5** Semántico
*   **CSS3** (Variables, Grid, Flexbox, Animations)
*   **JavaScript** (ES6+, Async/Await)
*   **SQL** (Diseño conceptual PostgreSQL)

## Créditos
Desarrollado por el equipo coordinado por **Antigravity**.
*   Dirección
*   Diseño UI/UX
*   Arquitectura de Datos
*   Seguridad
