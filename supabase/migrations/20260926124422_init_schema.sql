begin;

-- 1. EXTENSIONS & ENUMS
create schema IF not exists extensions;

create extension IF not exists postgis
with
  SCHEMA extensions;

-- gen_random_uuid() is built into modern Supabase PostgreSQL.
-- Respect PostGIS if it is already installed in another schema.
select
    pg_catalog.set_config (
            'search_path',
            'public,' || pg_catalog.quote_ident (n.nspname) || ',pg_catalog',
            true
    )
from
    pg_catalog.pg_extension e
        join pg_catalog.pg_namespace n on n.oid = e.extnamespace
where
    e.extname = 'postgis';

create type public.place_status as ENUM('pending', 'approved', 'rejected');

create type public.feature_type as ENUM('boolean', 'rating');

create type public.action_type as ENUM('CREATED', 'UPDATED', 'DELETED');

-- 2. TABLES, CONSTRAINTS & INDEXES
create table public.profiles
(
    id           uuid primary key references auth.users (id) on delete CASCADE,
    display_name text        not null default '',
    avatar_url   text,
    created_at   timestamptz not null default now(),
    updated_at   timestamptz not null default now()
);

create table public.categories
(
    id         uuid primary key     default gen_random_uuid(),
    slug       text        not null unique,
    name       text        not null,
    icon       text,
    sort_order integer     not null default 0,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table public.features
(
    id         uuid primary key     default gen_random_uuid(),
    slug       text        not null unique,
    name       text,
    type public.feature_type not null,
    icon       text,
    sort_order integer     not null default 0,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table public.purposes
(
    id         uuid primary key     default gen_random_uuid(),
    slug       text        not null unique,
    name       text,
    icon       text,
    sort_order integer     not null default 0,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table public.places
(
    id          uuid primary key     default gen_random_uuid(),
    name        text        not null,
    description text,
    category_id uuid        not null references public.categories (id) on delete RESTRICT,
    location    geography (Point, 4326) not null,
    address     text,
    postal_code text,
    city        text,
    created_by  uuid        references public.profiles (id) on delete set null,
    status public.place_status not null default 'approved',
    created_at  timestamptz not null default now(),
    updated_at  timestamptz not null default now()
);

create index places_location_idx on public.places using gist (location);
create index places_category_idx on public.places (category_id);
create index places_status_idx on public.places (status);
create index places_created_by_idx on public.places (created_by);

create table public.place_images
(
    id           uuid primary key     default gen_random_uuid(),
    place_id     uuid        not null references public.places (id) on delete CASCADE,
    storage_path text        not null unique,
    uploaded_by  uuid        references public.profiles (id) on delete set null,
    sort_order   integer     not null default 0,
    created_at   timestamptz not null default now(),
    updated_at   timestamptz not null default now()
);

create index place_images_place_idx on public.place_images (place_id);
create index place_images_uploaded_by_idx on public.place_images (uploaded_by);

create table public.place_features
(
    place_id      uuid        not null references public.places (id) on delete CASCADE,
    feature_id    uuid        not null references public.features (id) on delete CASCADE,
    boolean_value boolean,
    rating_value  smallint check (rating_value between 1 and 5),
    created_at    timestamptz not null default now(),
    updated_at    timestamptz not null default now(),
    primary key (place_id, feature_id)
);

create index place_features_feature_idx on public.place_features (feature_id);

create table public.place_purposes
(
    place_id   uuid not null references public.places (id) on delete CASCADE,
    purpose_id uuid not null references public.purposes (id) on delete CASCADE,
    primary key (place_id, purpose_id)
);

create index place_purposes_purpose_idx on public.place_purposes (purpose_id);

create table public.favorites
(
    user_id    uuid        not null references auth.users (id) on delete CASCADE,
    place_id   uuid        not null references public.places (id) on delete CASCADE,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    primary key (user_id, place_id)
);

create index favorites_place_idx on public.favorites (place_id);

create table public.bookmarks
(
    user_id    uuid        not null references auth.users (id) on delete CASCADE,
    place_id   uuid        not null references public.places (id) on delete CASCADE,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    primary key (user_id, place_id)
);

create index bookmarks_place_idx on public.bookmarks (place_id);

create table public.audit_logs
(
    id            uuid primary key     default gen_random_uuid(),
    actor_user_id uuid,
    entity_type   text        not null,
    entity_id     uuid,
    action public.action_type not null,
    old_data      jsonb,
    new_data      jsonb,
    created_at    timestamptz not null default now()
);

create index audit_logs_actor_user_idx on public.audit_logs (actor_user_id);
create index audit_logs_entity_idx on public.audit_logs (entity_type, entity_id);
create index audit_logs_created_at_idx on public.audit_logs (created_at);

COMMENT on column public.profiles.avatar_url is 'Public URL of an object in avatars: <user UUID>/<filename>.';
COMMENT on column public.place_images.storage_path is 'Object key in private place-images bucket: <uploader UUID>/<place UUID>/<filename>. No bucket prefix or signed URL.';

-- 3. FUNCTIONS
create function public.set_updated_at () RETURNS trigger LANGUAGE plpgsql
set
  search_path = '' as $$
BEGIN
  NEW.updated_at
:= now();
RETURN NEW;
END;
$$;

create function public.handle_new_user () RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER
set
  search_path = '' as $$
BEGIN
INSERT INTO public.profiles (id)
VALUES (NEW.id);

RETURN NEW;
END;
$$;

create function public.audit_row_change () RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER
set
  search_path = '' as $$
DECLARE
before_row jsonb;
  after_row
jsonb;
  operation
public.action_type;
BEGIN
  IF
TG_OP = 'INSERT' THEN
    after_row := to_jsonb(NEW);
    operation
:= 'CREATED';
  ELSIF
TG_OP = 'UPDATE' THEN
    before_row := to_jsonb(OLD);
    after_row
:= to_jsonb(NEW);
    operation
:= 'UPDATED';
ELSE
    before_row := to_jsonb(OLD);
    operation
:= 'DELETED';
END IF;

INSERT INTO public.audit_logs (actor_user_id,
                               entity_type,
                               entity_id,
                               action,
                               old_data,
                               new_data)
VALUES (auth.uid(),
        TG_TABLE_NAME,
        (COALESCE(after_row, before_row) ->>'id')::uuid,
        operation,
        before_row,
        after_row);

RETURN NULL;
END;
$$;

-- 4. TRIGGERS
create trigger on_auth_user_created
    after INSERT on auth.users for EACH row
    execute FUNCTION public.handle_new_user ();

-- Profile deletion is handled by ON DELETE CASCADE from auth.users.
do $$
DECLARE
table_name text;
BEGIN
  FOREACH
table_name IN ARRAY ARRAY[
    'profiles',
    'categories',
    'features',
    'purposes',
    'places',
    'place_images',
    'place_features',
    'favorites',
    'bookmarks'
  ]
  LOOP
    EXECUTE format(
      'CREATE TRIGGER set_updated_at
       BEFORE UPDATE ON public.%I
       FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()',
      table_name
    );
END LOOP;
END;
$$;

-- 5. AUDIT LOGGING & SECURITY
do $$
DECLARE
table_name text;
BEGIN
  FOREACH
table_name IN ARRAY ARRAY[
    'profiles',
    'categories',
    'features',
    'purposes',
    'places',
    'place_images',
    'place_features',
    'place_purposes',
    'favorites',
    'bookmarks'
  ]
  LOOP
    EXECUTE format(
      'CREATE TRIGGER audit_row_change
       AFTER INSERT OR UPDATE OR DELETE ON public.%I
       FOR EACH ROW EXECUTE FUNCTION public.audit_row_change()',
      table_name
    );
END LOOP;
END;
$$;

-- audit_logs deliberately does not audit itself.
-- Prevent direct application execution of trigger functions.
revoke all on FUNCTION public.set_updated_at ()
    from
    PUBLIC,
    anon,
    authenticated;

revoke all on FUNCTION public.handle_new_user ()
    from
    PUBLIC,
    anon,
    authenticated;

revoke all on FUNCTION public.audit_row_change ()
    from
    PUBLIC,
    anon,
    authenticated;

-- Enable RLS immediately so tables remain protected before file 02 runs.
do $$
DECLARE
table_name text;
BEGIN
  FOREACH
table_name IN ARRAY ARRAY[
    'profiles',
    'categories',
    'features',
    'purposes',
    'places',
    'place_images',
    'place_features',
    'place_purposes',
    'favorites',
    'bookmarks',
    'audit_logs'
  ]
  LOOP
    EXECUTE format(
      'ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY',
      table_name
    );

EXECUTE format(
        'REVOKE ALL ON TABLE public.%I FROM PUBLIC, anon, authenticated',
        table_name
        );

EXECUTE format(
        'GRANT ALL ON TABLE public.%I TO service_role',
        table_name
        );
END LOOP;
END;
$$;

insert into
    public.profiles (id)
select
    id
from
    auth.users
    on conflict (id) do nothing;

commit;