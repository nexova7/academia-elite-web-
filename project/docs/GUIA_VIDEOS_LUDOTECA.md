# 🎬 Guía de Estandarización de Video - Ludoteca Élite

Esta guía define el estándar técnico y de implementación para todos los videos educativos en la plataforma Academia Élite. Sigue estas reglas para garantizar la compatibilidad y la experiencia de usuario premium "Victoria Total".

## 1. Especificaciones del Archivo de Video 📼

Para asegurar reproducción en todos los navegadores (Chrome, Safari, Edge, Firefox, Móviles):

*   **Formato Contenedor**: `.mp4`
*   **Códec de Video**: H.264 (High Profile o Main Profile)
*   **Códec de Audio**: AAC (Advanced Audio Coding)
*   **Resolución Recomendada**: 1920x1080 (HD) o 1280x720 (SD)
*   **Metadatos**: Debe tener "Fast Start" (Web Optimized) habilitado al renderizar.
*   **Convención de Nombres**: `Nombre_Del_Video.mp4` (Usar guiones bajos, sin espacios ni caracteres especiales).

## 2. Estructura HTML (El "Formato Victoria") 🏗️

Usa este bloque exacto para cada tarjeta de video en la sección de lecciones.

```html
<!-- Tarjeta de Video Estandarizada -->
<div class="netflix-card no-hover-scale">
    <!-- Wrapper con onclick para activar la función JS -->
    <div class="thumb-wrapper" onclick="toggleVideo(this)" style="cursor: pointer; position: relative;">
        
        <!-- Etiqueta de Video -->
        <video playsinline preload="metadata" width="100%" height="100%" class="video-elite" style="object-fit: cover;">
            <!-- CAMBIAR SOLO LA RUTA 'src' -->
            <source src="videos-informativos/TU_VIDEO_AQUI.mp4" type="video/mp4">
            Tu navegador no soporta video HTML5.
        </video>

        <!-- Botón de Play Gigante (Overlay) -->
        <div class="custom-play-btn"
            style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: #c5a059; font-size: 50px; z-index: 100; text-shadow: 0 0 10px rgba(0,0,0,0.8); pointer-events: none;">
            <i class="fa-solid fa-circle-play"></i>
        </div>
    </div>

    <!-- Información de la Tarjeta -->
    <div class="card-info">
        <h4>Título del Video</h4>
        <div class="meta-row">
            <span class="duration">00 min</span> <!-- Ajustar Duración -->
            <label class="custom-checkbox">
                <input type="checkbox" class="progress-check" onchange="recalcProgress()">
                <span class="checkmark"></span>
                Visto
            </label>
        </div>
    </div>
</div>
```

## 3. Clases CSS Críticas (Ya incluidas en dashboard.css) 🎨

No modificar estas reglas, ya que garantizan la interacción correcta en móviles y escritorio.

*   `.no-hover-scale`: Deshabilita la animación de "zoom" en la tarjeta para no romper la interacción con los controles del video.
*   `.video-elite`: Asegura `z-index: 50` y `pointer-events: auto` para que el video siempre reciba el clic.
*   `.custom-play-btn`: Centrado absoluto, color dorado Élite, e invisible a los clics (`pointer-events: none`) para que el clic pase directo al video.

## 4. Lógica JavaScript (Sistema `toggleVideo`) ⚙️

Esta función ya está implementada en `dashboard-alumno.html`. No se requiere configuración adicional por video, funciona automáticamente con la estructura HTML de arriba.

```javascript
function toggleVideo(wrapper) {
    const video = wrapper.querySelector('video');
    const btn = wrapper.querySelector('.custom-play-btn');
    if (!video) return;

    if (video.paused) {
        // Intenta reproducir
        const playPromise = video.play();
        if (playPromise !== undefined) {
            playPromise.then(_ => {
                // Si arranca, muestra los controles nativos y oculta el botón gigante
                video.controls = true;
                if (btn) btn.style.display = 'none';
            })
            // ... manejo de errores
        }
    }
}
```

## 5. Pasos para agregar un nuevo video 📝

1.  **Copiar** el archivo `.mp4` a la carpeta `Academia_Elite/videos-informativos/`.
2.  **Duplicar** el bloque HTML de la "Tarjeta de Video Estandarizada" en `dashboard-alumno.html`.
3.  **Actualizar** el `src` del video, el título (`<h4>`) y la duración.
4.  **Listo**. El sistema se encarga del resto.
