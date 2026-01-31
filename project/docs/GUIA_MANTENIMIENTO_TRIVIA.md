# 📘 GUÍA DE MANTENIMIENTO: MÓDULO DE TRIVIA
**Academia de Conducción Élite**

Esta guía detalla los pasos para realizar el mantenimiento, actualización y edición del contenido del juego de trivia (preguntas e imágenes).

---

## 1. 📂 Ubicación de Archivos Clave

Para realizar cambios, debe acceder a las siguientes rutas en el proyecto:

### **A. Banco de Preguntas (Texto y Lógica)**
*   **Archivo:** `trivia_banco.js`
*   **Ruta Completa:** `c:\Users\visitante\Desktop\academia-app\Academia_Elite\js\trivia_banco.js`
*   **Descripción:** Contiene toda la información de las preguntas, opciones, respuestas correctas y retroalimentación en formato JSON.

### **B. Imágenes del Juego**
*   **Carpeta:** `trivia`
*   **Ruta Completa:** `c:\Users\visitante\Desktop\academia-app\Academia_Elite\images\trivia\`
*   **Descripción:** Contiene las imágenes vectoriales (SVG) o PNG que acompañan a cada pregunta.

---

## 2. 📝 Cómo Editar o Agregar Preguntas

### Paso 1: Abrir el archivo de datos
Abra el archivo `js\trivia_banco.js` con un editor de código (como VS Code o Notepad++).

### Paso 2: Entender la estructura
El archivo está organizado por niveles (`1`, `2`, `3`). Cada pregunta es un bloque de código como este:

```javascript
{
    id: 1,
    q: "Texto de la pregunta aquí...",
    img: "images/trivia/1.svg",  // Ruta de la imagen
    options: [
        "Opción A",
        "Opción B",
        "Opción C"
    ],
    correct: 1, // Índice de la respuesta correcta (0 es la primera opción)
    feedback: "Texto de explicación que sale al responder."
}
```

### Paso 3: Realizar cambios
*   **Editar Texto:** Cambie simplemente el texto dentro de las comillas en `q` (pregunta) u `options`.
*   **Cambiar Respuesta Correcta:** Modifique el número en `correct`. Recuerde:
    *   `0` = Primera opción
    *   `1` = Segunda opción
    *   `2` = Tercera opción
*   **Agregar Nueva Pregunta:** Copie y pegue un bloque completo y asegúrese de actualizar el `id` para que sea único.

---

## 3. 🖼️ Cómo Cambiar Imágenes

El sistema utiliza imágenes locales para garantizar que funcionen sin internet.

### Paso 1: Preparar la imagen
*   Use formato **SVG** (recomendado para vectores) o **PNG**.
*   Nombre el archivo coincidiendo con el ID de la pregunta (ej. `5.png` o `5.svg`).

### Paso 2: Guardar el archivo
*   Copie la imagen en la carpeta: `Academia_Elite\images\trivia\`

### Paso 3: Vincular en el código
*   En `trivia_banco.js`, busque la pregunta correspondiente.
*   Actualice la propiedad `img`:
    ```javascript
    img: "images/trivia/nueva_imagen.png",
    ```

---

## 4. 🚀 Generación Automática de Imágenes (Avanzado)

Si necesita regenerar las imágenes SVG por defecto, se ha creado un script de automatización.

*   **Script:** `generate_svgs.ps1`
*   **Ubicación:** Raíz de `Academia_Elite`
*   **Ejecución:**
    1.  Abrir PowerShell.
    2.  Ejecutar: `.\generate_svgs.ps1`
    3.  Esto creará nuevamente los archivos en la carpeta de imágenes basándose en el código del script.

---
**Nota:** Cualquier cambio en `trivia_banco.js` se refleja inmediatamente en el navegador al recargar la página `evaluacion.html`. No requiere compilación.
