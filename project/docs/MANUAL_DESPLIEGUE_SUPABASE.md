# 🚀 Manual de Despliegue en Supabase (Paso a Paso)

Este documento te guiará para aplicar los cambios de base de datos y almacenamiento en tu proyecto en la nube.

## 1. Ingresar a Supabase
1. Abre tu navegador y ve a: [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Inicia sesión con tus credenciales.
3. Selecciona tu proyecto: **"Academia Elite"** (o el nombre que tenga, ID: `aldwcqpgsjfjcttxfecp`).

## 2. Aplicar Cambios de Base de Datos (Tablas y Seguridad)
1. En la barra lateral izquierda, busca el ícono de **SQL Editor** (parece una hoja con `SQL` o `<_>`).
2. Haz clic en **"New Query"** (Nueva Consulta) arriba a la izquierda.
3. En tu ordenador, abre el archivo:
   `c:\Users\visitante\Desktop\academia-app\project\database\UPGRADE_SCHEMA_V2.sql`
   *(Puedes abrirlo con el Bloc de Notas)*.
4. **COPIA** todo el contenido del archivo.
5. **PEGA** el contenido en el área blanca del editor de Supabase.
6. Haz clic en el botón verde **"Run"** (Ejecutar) abajo a la derecha.
   * *Si todo sale bien, verás un mensaje "Success" en la parte inferior.*

## 3. Configurar Almacenamiento (Imágenes y Videos)
1. En el mismo **SQL Editor** de Supabase, borra lo que acabas de ejecutar (o crea otra "New Query").
2. En tu ordenador, abre el archivo:
   `c:\Users\visitante\Desktop\academia-app\project\database\STORAGE_SETUP.sql`
3. **COPIA** todo el contenido.
4. **PEGA** el contenido en el editor de Supabase.
5. Haz clic en el botón verde **"Run"** (Ejecutar).

## 4. Verificar
1. Ve al ícono **Table Editor** (icono de tabla en la barra lateral) y verifica que existan tablas como `alumnos`, `reservas_clases`.
2. Ve al ícono **Storage** (icono de carpeta/cubo) y verifica que existan los buckets `avatars` y `material-estudio`.

---
**¡Listo! Tu backend está actualizado.**
