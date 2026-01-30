-- ACTUALIZACIÓN DE SCHEMA: ACADEMIA ÉLITE
-- Este script actualiza la base de datos Supabase para soportar todas las funcionalidades
-- del Dashboard de Alumno, Instructor y la nueva Videoteca.

-- 1. TABLA: ALUMNOS (Perfiles Extendidos)
create table if not exists public.alumnos (
  id uuid references auth.users not null primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  email text,
  nombre text,
  whatsapp text,
  categoria text default 'B1',
  avatar_url text,
  clases_completadas int default 0,
  progreso int default 0, -- Porcentaje de avance global (Licencia)
  rol text default 'alumno', -- 'alumno', 'instructor', 'admin'
  
  constraint alumnos_email_key unique (email)
);

-- Habilitar RLS para Alumnos
alter table public.alumnos enable row level security;

create policy "Alumnos pueden ver su propio perfil" 
  on public.alumnos for select 
  using ( auth.uid() = id );

create policy "Alumnos pueden actualizar su propio perfil" 
  on public.alumnos for update 
  using ( auth.uid() = id );

-- Permitir que instructores vean todos los alumnos
create policy "Instructores ven todos los alumnos"
  on public.alumnos for select
  using ( 
    exists (
      select 1 from public.alumnos 
      where id = auth.uid() and rol = 'instructor'
    ) 
  );


-- 2. TABLA: RESERVAS_CLASES
create table if not exists public.reservas_clases (
  id uuid default uuid_generate_v4() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  alumno_id uuid references public.alumnos(id) not null,
  instructor text not null, -- Nombre del instructor (o referencia si hubiera tabla instructores)
  fecha date not null,
  hora text not null,
  notas text,
  estado text default 'CONFIRMADA', -- 'CONFIRMADA', 'CANCELADA', 'COMPLETADA'

  constraint valid_estado check (estado in ('CONFIRMADA', 'CANCELADA', 'COMPLETADA'))
);

-- Habilitar RLS para Reservas
alter table public.reservas_clases enable row level security;

create policy "Alumnos ven sus propias reservas"
  on public.reservas_clases for select
  using ( auth.uid() = alumno_id );

create policy "Alumnos pueden crear reservas"
  on public.reservas_clases for insert
  with check ( auth.uid() = alumno_id );

create policy "Instructores ven todas las reservas"
  on public.reservas_clases for select
  using ( 
     exists (
      select 1 from public.alumnos 
      where id = auth.uid() and rol = 'instructor'
    ) 
  );

create policy "Alumnos pueden cancelar (update) sus reservas"
  on public.reservas_clases for update
  using ( auth.uid() = alumno_id );


-- 3. TABLA: NOTAS_ALUMNOS (Feedback de Instructores)
create table if not exists public.notas_alumnos (
  id uuid default uuid_generate_v4() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  alumno_id uuid references public.alumnos(id) not null,
  instructor text, -- Nombre del instructor que deja la nota
  fecha date default CURRENT_DATE,
  texto text not null
);

-- Habilitar RLS para Notas
alter table public.notas_alumnos enable row level security;

create policy "Alumnos ven sus propias notas"
  on public.notas_alumnos for select
  using ( auth.uid() = alumno_id );

create policy "Instructores pueden crear notas"
  on public.notas_alumnos for insert
  with check ( 
    exists (
      select 1 from public.alumnos 
      where id = auth.uid() and rol = 'instructor'
    ) 
  );


-- 4. TRIGGER: Para crear perfil de alumno automáticamente al registrarse en Auth
-- Nota: Esto requiere privilegios de superadmin en Supabase
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.alumnos (id, email, nombre, rol)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name', 'alumno');
  return new;
end;
$$ language plpgsql security definer;

-- Trigger (solo si no existe, difícil de validar en script puro sin bloques)
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- FIN DEL SCRIPT
