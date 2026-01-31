# 🛡️ Guía de Seguridad Máxima: Supabase & Academia Élite

## ✅ Misión Cumplida

He implementado una estrategia de **"Seguridad en Profundidad"** para tu proyecto. A diferencia de las bases de datos tradicionales ocultas detrás de un firewall, Supabase vive en la nube, por lo que tu **Primera Línea de Defensa** es la base de datos misma.

Hemos realizado las siguientes acciones para blindar tu aplicación:

1.  **Refactorización del Cliente**: Hemos movido las claves a `js/supabase-config.js` para centralizar la conexión.
2.  **Limpieza de Código**: Se eliminaron las credenciales hardcodeadas de `acceso-alumnos.html` y `dashboard-alumno.html`.
3.  **Protocolo RLS (Row Level Security)**: Se ha preparado un nuevo script SQL que asegura que **NADIE** pueda ver datos que no le pertenecen.

---

## 🚀 Paso 1: Activar el Escudo (SQL)

La seguridad real reside en PostgreSQL. Debes ejecutar el script de seguridad que he generado.

1.  Ve al dashboard de Supabase (https://app.supabase.com).
2.  Abre el **SQL Editor**.
3.  Copia el contenido del archivo:
    `project/database/SUPABASE_SECURITY_V2.sql`
4.  Pégalo y ejecútalo (**Run**).

**¿Qué hace esto?**
-   🔒 **Bloquea `leads`**: Permite que cualquier persona se registre (insertar), pero **NADIE** puede leer la lista de leads desde la web (evita robo de base de datos).
-   🔒 **Valida Emails**: Rechaza correos mal formados directamente en el servidor.
-   🔒 **Protege Resultados**: Asegura la tabla de trivia.
-   🔒 **Ajusta Visibilidad**: Asegura que los instructores solo sean visibles si están "activos".

---

## 💻 Paso 2: Entendiendo la Arquitectura

Tu frontend (`HTML/JS`) ahora carga la configuración desde un solo lugar:
`Academia_Elite/js/supabase-config.js`

```javascript
const SUPABASE_PROJECT_URL = '...';
const SUPABASE_ANON_KEY = 'sb_publishable_...';
```

### ⚠️ Regla de Oro (NO NEGOCIABLE)
**NUNCA, BAJO NINGUNA CIRCUNSTANCIA**, pongas la `service_role` key (la clave secreta que empieza usualmente por `ey...` y dice "secret") en este archivo o en ningún lugar del código Frontend.

-   ✅ **Anon Key**: Es pública. Es como la dirección de tu casa; la gente puede saber dónde vives, pero no pueden entrar si la puerta (RLS) está cerrada.
-   ❌ **Service Role Key**: Es la llave maestra. Si la pones en el código, **TE HACKEARÁN**.

---

## 🧪 Paso 3: Verificación

Después de ejecutar el SQL, prueba lo siguiente:

1.  **Registro**: Intenta registrarte en `acceso-alumnos.html`. Debería funcionar.
2.  **Intento de Hackeo (Simulado)**:
    Si abres la consola del navegador e intentas:
    ```javascript
    await supabaseInstance.from('leads').select('*')
    ```
    **Debería devolver un array vacío `[]` o un error.** Esto significa que la seguridad funciona. Aunque la clave es pública, la base de datos se niega a entregar informacion sensible.

---

## 🔄 Mantenimiento Futuro

Si necesitas cambiar las claves en el futuro (por ejemplo, si "rotas" las llaves en Supabase):
1.  Solo edita `Academia_Elite/js/supabase-config.js`.
2.  No tienes que tocar ningún HTML.

¡Tu academia ahora es una fortaleza digital! 🏰
