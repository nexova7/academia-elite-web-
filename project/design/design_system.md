# Academia de Conducción Élite - Design System "Prestige"

**Rol**: Diseñador Principal
**Versión**: 1.0

## 1. Filosofía Visual
*   **Concepto**: "Lujo Nocturno". Evoca exclusividad, velocidad controlada y elegancia.
*   **Atmósfera**: Misteriosa pero accesible. Minimalista. Sin ruido visual.

## 2. Paleta de Colores

### Bases (Dark Mode Nativo)
*   **Rich Black**: `#0A0A0A` (Fondo principal - No usar negro absoluto #000)
*   **Charcoal Grey**: `#1F1F1F` (Tarjetas, secciones secundarias)
*   **Gunmetal**: `#2D2D2D` (Bordes sutiles, inputs inactivos)

### Acentos (Brand Identity)
*   **Elite Red**: `#C41E3A` (Rojo cardenal vibrante - CTAs Primarios, highlights)
*   **Prestige Gold**: `#D4AF37` (Detalles finos, iconos, bordes de foco, texto de lujo)
*   **Pure White**: `#FFFFFF` (Texto principal - Usar con opacidad 95% para lectura)

### Semántica
*   **Success**: `#10B981` (Verde esmeralda apagado)
*   **Error**: `#EF4444` (Rojo brillante, distinto al Elite Red)
*   **Warning**: `#F59E0B` (Ámbar)

## 3. Tipografía

### Headings (Lujo y Estilo)
*   **Familia**: `Playfair Display` (Google Fonts)
*   **Uso**: H1, H2, Cifras grandes.
*   **Peso**: 700 (Bold) para títulos, 400 (Regular) para subtítulos elegantes.
*   *Estilo*: Letter-spacing ligero para aire (-0.02em).

### Body (Legibilidad y Técnica)
*   **Familia**: `Inter` o `Outfit` (Google Fonts).
*   **Uso**: Párrafos, UI, Botones, Trivia.
*   **Peso**: 300 (Light), 400 (Regular), 600 (SemiBold).

## 4. Componentes Core

### Botones
1.  **Primario (CTA)**: Fondo `Elite Red`, Texto `White`, Border-radius `2px` (cuadrado técnico), Sombra resplandor suave roja al hover.
2.  **Secundario (Ghost)**: Borde `Prestige Gold`, Texto `Prestige Gold`, Fondo transparente. Hover: Fondo `Prestige Gold` (10% opacidad).

### Tarjetas (Cards)
*   Fondo `Charcoal Grey`.
*   Borde finísimo (1px) `Gunmetal`.
*   Efecto Glassmorphism sutil (Backdrop-filter blur 10px) si aplica sobre imágenes.

### Inputs (Formularios/Trivia)
*   Fondo `Rich Black`.
*   Borde inferior `Gunmetal` (Underline style).
*   Foco: Borde inferior `Prestige Gold` + Transición suave.

## 5. Iconografía
*   Líneas finas (1.5px stroke).
*   Color: `Prestige Gold` o `White`.
*   Librería sugerida: Phosphor Icons o Heroicons (Outline).
