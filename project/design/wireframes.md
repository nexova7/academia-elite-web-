# Wireframes y Flujos de Usuario - Academia Élite

## 1. Landing Page (Home)

**Estructura**: Single Page Scroll (SPA feeling).

### A. Hero Section (Pantalla Completa)
*   **Fondo**: Imagen/Video oscuro de un coche deportivo en pista nocturna (Overlay negro 60%).
*   **Contenido Central**:
    *   H1: "Domina la Máquina." (Playfair Display)
    *   Subtítulo: "La academia de conducción más exclusiva del país." (Inter Light)
    *   CTA Principal: "Inicar Evaluación" (Red Button) -> Lleva a Trivia.
*   **Navegación (Sticky Top)**:
    *   Logo (Izquierda): Texto dorado "ÉLITE".
    *   Links (Derecha, minimal): Servicios | Flota | Contacto | **Acceso Alumnos** (Borde dorado).

### B. Sección "La Flota" (Carrusel)
*   Título: "Ingeniería de Precisión".
*   Tarjetas de vehículos (Porsche, BMW M, Ferrari) flotando sobre fondo Charcoal.
*   Datos técnicos visibles al hover (Horsepower, 0-100).

### C. Teaser Trivia (Hook)
*   **Fondo**: Degradado sutil Rojo a Negro.
*   **Copy**: "¿Crees que sabes conducir? Demuéstralo."
*   **Interacción**: Input simple "¿Cuál es tu nombre?" -> Botón "Comenzar Reto".

### D. Footer Minimal
*   Enlaces legales.
*   Redes sociales (Iconos dorados).

---

## 2. Módulo de Trivia (Lead Magnet)

**Objetivo**: Validar conocimientos del usuario y captar datos.

### Pantalla 1: Bienvenida
*   "Evaluación de Aptitud de Piloto".
*   Texto breve legal sobre uso de datos.
*   Botón: "Arrancar Motores".

### Pantalla 2: Preguntas (Iterativa, slide horizontal)
*   Barra de progreso (Línea roja delgada superior).
*   **Pregunta**: Texto grande H2.
*   **Opciones**: 4 Tarjetas grandes.
    *   Hover: Borde dorado.
    *   Selección: Fondo Charcoal + Check dorado.
*   Feedback inmediato (Sin recarga):
    *   Correcto: Destello verde sutil + Sonido sutil.
    *   Incorrecto: Vibración roja + Explicación técnica breve.

### Pantalla 3: Resultados (Lead Gen)
*   Score circular animado (Ej: "85% Aptitud").
*   Mensaje condicional:
    *   High Score: "Nivel Piloto Élite. Te invitamos a una prueba de pista gratuita."
    *   Low Score: "Necesitas pulir técnica. Empieza con el Curso Avanzado."
*   **Formulario Final**: Email + Teléfono para "Recibir Certificado/Resultados".

---

## 3. UI States

*   **Loading**: Logotipo "ÉLITE" pulsando en dorado sobre negro.
*   **Error**: Toast notification discreto en esquina superior derecha (Borde rojo).
