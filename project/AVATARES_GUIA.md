# Sistema de Avatares Élite - Guía de Uso
## Dashboard de Estudiantes

---

## ✅ **Estado Actual**

### **Avatares Disponibles: 7**

| # | Archivo | Tipo | Estado |
|---|---------|------|--------|
| 1 | `mascota masculina.png` | Avatar por defecto | ✅ Activo |
| 2 | `pixel_avatar_men_1.png` | Masculino | ✅ Disponible |
| 3 | `pixel_avatar_men_2.png` | Masculino | ✅ Disponible |
| 4 | `pixel_avatar_men_3.png` | Masculino | ✅ Disponible |
| 5 | `pixel_avatar_women_1.png` | Femenino | ✅ Disponible |
| 6 | `pixel_avatar_women_2.png` | Femenino | ✅ Disponible |
| 7 | `pixel_avatar_women_3.png` | Femenino | ✅ Disponible |

---

## 🎨 **Funcionalidad Implementada**

### **1. Selector de Avatares**

**Ubicación:** Dashboard → Sección "Perfil" → Lado izquierdo

**Cómo funciona:**
1. El usuario ve su avatar actual (200x200px con borde dorado)
2. Debajo hay un botón dorado: **"AVATARES ÉLITE"**
3. Al hacer clic, se despliega un grid de 3x2 con los 6 avatares
4. Al seleccionar uno, se actualiza la imagen y el grid se cierra

---

## 🔧 **Código Actualizado**

### **JavaScript (Funciones)**

```javascript
// Función para mostrar/ocultar grid de avatares
function toggleAvatars() {
    const grid = document.getElementById('avatarGrid');
    grid.classList.toggle('show'); // Usa clase CSS
}

// Función para cambiar avatar
function changePfp(src) {
    document.getElementById('pfp').src = src;
    document.getElementById('avatarGrid').classList.remove('show');
}
```

### **CSS (Estilos)**

```css
/* Grid de avatares (oculto por defecto) */
.avatar-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.5s ease;
}

/* Grid visible */
.avatar-grid.show {
    max-height: 500px;
}

/* Cada avatar */
.avatar-opt {
    width: 100%;
    aspect-ratio: 1;
    object-fit: cover;
    border-radius: 12px;
    border: 2px solid var(--elite-border);
    cursor: pointer;
    transition: all 0.3s ease;
}

/* Hover en avatar */
.avatar-opt:hover {
    border-color: var(--elite-gold);
    transform: scale(1.05);
    box-shadow: 0 0 15px var(--elite-gold-glow);
}
```

---

## 🎯 **Cómo Usar (Usuario Final)**

### **Paso 1: Acceder al Perfil**
1. Abrir `dashboard-alumno.html`
2. Clic en "👤 Mi Perfil" en el sidebar

### **Paso 2: Ver Avatares**
1. En la sección de perfil, buscar el avatar actual
2. Debajo verás el botón dorado **"AVATARES ÉLITE"**
3. Hacer clic en el botón

### **Paso 3: Seleccionar Avatar**
1. Se despliega un grid con 6 opciones
2. Hacer clic en el avatar deseado
3. El avatar se actualiza automáticamente
4. El grid se cierra

### **Paso 4: Guardar Cambios**
1. Scroll hacia abajo
2. Clic en **"GUARDAR CAMBIOS"** (botón dorado grande)
3. El avatar se guarda en Supabase (columna `avatar_url`)

---

## 📱 **Responsive**

### **Desktop (> 1200px)**
- Grid: 3 columnas
- Tamaño: ~80px por avatar

### **Tablet (768-1200px)**
- Grid: 3 columnas
- Tamaño: ~70px por avatar

### **Mobile (< 768px)**
- Grid: 2 columnas
- Tamaño: ~100px por avatar

---

## 🎨 **Efectos Visuales**

### **Botón "AVATARES ÉLITE"**
- Color: Dorado (#c5a059)
- Borde: 2px dorado
- Hover: Fondo dorado translúcido + glow
- Cursor: Pointer

### **Grid de Avatares**
- Animación: Expansión suave (0.5s)
- Espaciado: 12px entre avatares
- Fondo: Transparente

### **Cada Avatar**
- Borde: 2px gris (#2a2a2a)
- Hover: Borde dorado + escala 1.05 + glow
- Clic: Actualiza imagen principal

---

## 🔄 **Flujo Completo**

```
1. Usuario hace clic en "AVATARES ÉLITE"
   ↓
2. Grid se expande con animación suave
   ↓
3. Usuario ve 6 opciones en grid 3x2
   ↓
4. Usuario hace hover → avatar se ilumina en dorado
   ↓
5. Usuario hace clic → avatar se actualiza
   ↓
6. Grid se cierra automáticamente
   ↓
7. Usuario hace clic en "GUARDAR CAMBIOS"
   ↓
8. Avatar se guarda en Supabase
```

---

## 🧪 **Prueba de Funcionalidad**

### **Test 1: Abrir Grid**
```
Acción: Clic en "AVATARES ÉLITE"
Resultado esperado: Grid se expande mostrando 6 avatares
```

### **Test 2: Seleccionar Avatar**
```
Acción: Clic en cualquier avatar del grid
Resultado esperado: 
- Avatar principal se actualiza
- Grid se cierra
```

### **Test 3: Guardar**
```
Acción: Clic en "GUARDAR CAMBIOS"
Resultado esperado:
- Mensaje "¡ÉXITO! Tu perfil Élite ha sido actualizado."
- Avatar se guarda en Supabase
```

### **Test 4: Persistencia**
```
Acción: Cerrar sesión y volver a entrar
Resultado esperado: Avatar guardado se mantiene
```

---

## 📊 **Integración con Supabase**

### **Tabla: alumnos**
```sql
avatar_url TEXT  -- Guarda la ruta del avatar seleccionado
```

### **Actualización**
```javascript
await supabaseClient
    .from('alumnos')
    .update({ avatar_url: userAvatar })
    .eq('id', currentUserId);
```

### **Carga**
```javascript
if (data.avatar_url) {
    document.getElementById('pfp').src = data.avatar_url;
}
```

---

## 🎯 **Características Implementadas**

- [x] 6 avatares pixel art disponibles
- [x] Grid responsive (3x2 desktop, 2x3 mobile)
- [x] Animación de expansión suave
- [x] Hover effects con glow dorado
- [x] Actualización instantánea al seleccionar
- [x] Cierre automático del grid
- [x] Guardado en Supabase
- [x] Persistencia entre sesiones
- [x] Opción de subir foto propia (botón +)

---

## 🚀 **Mejoras Futuras (Opcional)**

### **Opción 1: Más Avatares**
- Agregar más archivos PNG al directorio
- Actualizar HTML con nuevas referencias

### **Opción 2: Categorías**
- Separar por género con pestañas
- Filtros por estilo

### **Opción 3: Upload Mejorado**
- Integración con Supabase Storage
- Crop de imagen antes de subir
- Validación de tamaño/formato

---

## ✅ **Estado Final**

**Funcionalidad:** ✅ 100% Operativa  
**Avatares:** ✅ 7 disponibles (1 default + 6 seleccionables)  
**Diseño:** ✅ Luxury dark mode con efectos élite  
**Responsive:** ✅ Funciona en todos los dispositivos  
**Integración:** ✅ Conectado a Supabase  

---

## 📸 **Vista Previa**

Para ver el sistema en acción:

1. Abrir: `C:\Users\visitante\Desktop\academia-app\Academia_Elite\dashboard-alumno.html`
2. Ir a la sección "Mi Perfil"
3. Buscar el avatar con borde dorado
4. Clic en "AVATARES ÉLITE"
5. ¡Disfrutar de la selección!

---

**✨ Sistema de Avatares Élite - Completamente Funcional ✨**
