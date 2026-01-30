-- CONFIGURACIÓN DE STORAGE (ALMACENAMIENTO)
-- Requiere privilegios de admin o debe ejecutarse en el SQL Editor de Supabase.

-- 1. BUCKET: AVATARES
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- Políticas de seguridad para Avatares
create policy "Avatares son públicos para ver"
  on storage.objects for select
  using ( bucket_id = 'avatars' );

create policy "Usuarios pueden subir su propio avatar"
  on storage.objects for insert
  with check ( 
    bucket_id = 'avatars' and 
    auth.uid() = (storage.foldername(name))[1]::uuid 
  );
  -- Nota: Esto asume una estructura de carpetas tipo /userid/filename. 
  -- Si se suben a la raíz, la policy debe ser diferente.
  -- Simplificado para el proyecto: Permitir insert a autenticados.

create policy "Usuarios autenticados pueden subir avatares"
  on storage.objects for insert
  with check ( bucket_id = 'avatars' and auth.role() = 'authenticated' );


-- 2. BUCKET: MATERIAL DE ESTUDIO (VIDEOTECA)
insert into storage.buckets (id, name, public)
values ('material-estudio', 'material-estudio', true) -- Público para facilidad de streaming
on conflict (id) do nothing;

create policy "Material es público"
  on storage.objects for select
  using ( bucket_id = 'material-estudio' );

-- Solo Instructores/Admins suben material
create policy "Instructores suben material"
  on storage.objects for insert
  with check ( 
    bucket_id = 'material-estudio' and 
    exists (
      select 1 from public.alumnos 
      where id = auth.uid() and rol = 'instructor'
    )
  );
