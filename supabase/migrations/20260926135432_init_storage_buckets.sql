begin;

insert into
    storage.buckets (
    id,
    name,
    public,
    file_size_limit,
    allowed_mime_types
)
values
    (
        'avatars',
        'avatars',
        true,
        5242880,
        array['image/jpeg', 'image/png', 'image/webp']
    ),
    (
        'place-images',
        'place-images',
        false,
        10485760,
        array['image/jpeg', 'image/png', 'image/webp']
    )
    on conflict (id) do update
                            set
                            public = EXCLUDED.public,
                            file_size_limit = EXCLUDED.file_size_limit,
                            allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Supabase manages storage.objects and its RLS configuration.
-- 1. AVATARS
drop policy IF exists fms_avatars_read on storage.objects;

create policy fms_avatars_read on storage.objects for
select
    to authenticated using (
    bucket_id = 'avatars'
    and owner_id = (
    select
    auth.uid ()::text
    )
    and split_part(name, '/', 1) = (
    select
    auth.uid ()::text
    )
    );

drop policy IF exists fms_avatars_insert on storage.objects;

create policy fms_avatars_insert on storage.objects for INSERT to authenticated
with
  check (
    bucket_id = 'avatars'
    and owner_id = (
      select
        auth.uid ()::text
    )
    and split_part(name, '/', 1) = (
      select
        auth.uid ()::text
    )
    and array_length(string_to_array(name, '/'), 1) = 2
    and split_part(name, '/', 2) <> ''
  );

drop policy IF exists fms_avatars_update on storage.objects;

create policy fms_avatars_update on storage.objects
for update
                                to authenticated using (
                                bucket_id = 'avatars'
                                and owner_id = (
                                select
                                auth.uid ()::text
                                )
                                and split_part(name, '/', 1) = (
                                select
                                auth.uid ()::text
                                )
                                )
    with
                                check (
                                bucket_id = 'avatars'
                                and owner_id = (
                                select
                                auth.uid ()::text
                                )
                                and split_part(name, '/', 1) = (
                                select
                                auth.uid ()::text
                                )
                                and array_length(string_to_array(name, '/'), 1) = 2
                                and split_part(name, '/', 2) <> ''
                                );

drop policy IF exists fms_avatars_delete on storage.objects;

create policy fms_avatars_delete on storage.objects for DELETE to authenticated using (
  bucket_id = 'avatars'
  and owner_id = (
    select
      auth.uid ()::text
  )
  and split_part(name, '/', 1) = (
    select
      auth.uid ()::text
  )
);

-- 2. PLACE IMAGES
-- Uploaders can read their own objects, including unlinked uploads.
-- Others can read linked objects only when the place is visible through RLS.
drop policy IF exists fms_place_images_read on storage.objects;

create policy fms_place_images_read on storage.objects for
select
    to anon,
    authenticated using (
    bucket_id = 'place-images'
    and (
    (
    owner_id = (
    select
    auth.uid ()::text
    )
    and split_part(name, '/', 1) = (
    select
    auth.uid ()::text
    )
    )
    or exists (
    select
    1
    from
    public.place_images i
    join public.places p on p.id = i.place_id
    where
    i.storage_path = storage.objects.name
    )
    )
    );

drop policy IF exists fms_place_images_insert on storage.objects;

create policy fms_place_images_insert on storage.objects for INSERT to authenticated
with
  check (
    bucket_id = 'place-images'
    and owner_id = (
      select
        auth.uid ()::text
    )
    and split_part(name, '/', 1) = (
      select
        auth.uid ()::text
    )
    and array_length(string_to_array(name, '/'), 1) = 3
    and split_part(name, '/', 3) <> ''
    and exists (
      select
        1
      from
        public.places p
      where
        p.id::text = split_part(name, '/', 2)
    )
  );

drop policy IF exists fms_place_images_delete on storage.objects;

create policy fms_place_images_delete on storage.objects for DELETE to authenticated using (
  bucket_id = 'place-images'
  and owner_id = (
    select
      auth.uid ()::text
  )
  and split_part(name, '/', 1) = (
    select
      auth.uid ()::text
  )
);

-- No UPDATE policy for place images: object paths remain stable.
commit;