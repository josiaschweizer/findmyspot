begin;

grant USAGE on SCHEMA public to anon,
authenticated,
service_role;

-- Remove table-level application privileges before granting specific access.
revoke all on table public.profiles,
    public.categories,
    public.features,
    public.purposes,
    public.places,
    public.place_images,
    public.place_features,
    public.place_purposes,
    public.favorites,
    public.bookmarks,
    public.audit_logs
    from
    PUBLIC,
    anon,
    authenticated;

-- 1. PROFILES
grant
    select
    on public.profiles to authenticated;

grant
    update (display_name, avatar_url) on public.profiles to authenticated;

drop policy IF exists profiles_read_self on public.profiles;

create policy profiles_read_self on public.profiles for
select
    to authenticated using (
    id = (
    select
    auth.uid ()
    )
    );

drop policy IF exists profiles_update_self on public.profiles;

create policy profiles_update_self on public.profiles
for update
                    to authenticated using (
                    id = (
                    select
                    auth.uid ()
                    )
                    )
    with
                    check (
                    id = (
                    select
                    auth.uid ()
                    )
                    );

-- profile creation/deletion follows auth.users.
-- account deletion must use a trusted backend / Supabase Auth Admin API.
-- 2. CATEGORIES, FEATURES & PURPOSES
grant
select
on public.categories,
    public.features,
    public.purposes to anon,
    authenticated;

drop policy IF exists categories_read on public.categories;

create policy categories_read on public.categories for
select
    to anon,
    authenticated using (true);

drop policy IF exists features_read on public.features;

create policy features_read on public.features for
select
    to anon,
    authenticated using (true);

drop policy IF exists purposes_read on public.purposes;

create policy purposes_read on public.purposes for
select
    to anon,
    authenticated using (true);

-- No application write policies: managed by the service role / database owner.
-- 3. PLACES
grant
    select
    on public.places to anon,
    authenticated;

grant INSERT (
              id,
              name,
              description,
              category_id,
              location,
              address,
              postal_code,
              city,
              created_by
    ) on public.places to authenticated;

grant
    update (
            name,
            description,
            category_id,
            location,
            address,
            postal_code,
            city
    ) on public.places to authenticated;

grant DELETE on public.places to authenticated;

drop policy IF exists places_read on public.places;

create policy places_read on public.places for
select
    to anon,
    authenticated using (
    status = 'approved'
    or created_by = (
    select
    auth.uid ()
    )
    );

drop policy IF exists places_create on public.places;

create policy places_create on public.places for INSERT to authenticated
with
  check (
    created_by = (
      select
        auth.uid ()
    )
    and status = 'approved'
  );

drop policy IF exists places_update on public.places;

create policy places_update on public.places
for update
                                to authenticated using (
                                created_by = (
                                select
                                auth.uid ()
                                )
                                )
    with
                                check (
                                created_by = (
                                select
                                auth.uid ()
                                )
                                );

drop policy IF exists places_delete on public.places;

create policy places_delete on public.places for DELETE to authenticated using (
  created_by = (
    select
      auth.uid ()
  )
);

-- 4. PLACE FEATURES
grant
    select
    on public.place_features to anon,
    authenticated;

grant INSERT (place_id, feature_id, boolean_value, rating_value) on public.place_features to authenticated;

grant
    update (boolean_value, rating_value) on public.place_features to authenticated;

grant DELETE on public.place_features to authenticated;

-- Subqueries into places inherit its RLS visibility rules.
drop policy IF exists place_features_read on public.place_features;

create policy place_features_read on public.place_features for
select
    to anon,
    authenticated using (
    exists (
    select
    1
    from
    public.places p
    where
    p.id = place_features.place_id
    )
    );

drop policy IF exists place_features_create on public.place_features;

create policy place_features_create on public.place_features for INSERT to authenticated
with
  check (
    exists (
      select
        1
      from
        public.places p
      where
        p.id = place_features.place_id
        and p.created_by = (
          select
            auth.uid ()
        )
    )
  );

drop policy IF exists place_features_update on public.place_features;

create policy place_features_update on public.place_features
for update
                                to authenticated using (
                                exists (
                                select
                                1
                                from
                                public.places p
                                where
                                p.id = place_features.place_id
                                and p.created_by = (
                                select
                                auth.uid ()
                                )
                                )
                                )
    with
                                check (
                                exists (
                                select
                                1
                                from
                                public.places p
                                where
                                p.id = place_features.place_id
                                and p.created_by = (
                                select
                                auth.uid ()
                                )
                                )
                                );

drop policy IF exists place_features_delete on public.place_features;

create policy place_features_delete on public.place_features for DELETE to authenticated using (
  exists (
    select
      1
    from
      public.places p
    where
      p.id = place_features.place_id
      and p.created_by = (
        select
          auth.uid ()
      )
  )
);

-- 5. PLACE PURPOSES
grant
    select
    on public.place_purposes to anon,
    authenticated;

grant INSERT (place_id, purpose_id) on public.place_purposes to authenticated;

grant DELETE on public.place_purposes to authenticated;

drop policy IF exists place_purposes_read on public.place_purposes;

create policy place_purposes_read on public.place_purposes for
select
    to anon,
    authenticated using (
    exists (
    select
    1
    from
    public.places p
    where
    p.id = place_purposes.place_id
    )
    );

drop policy IF exists place_purposes_create on public.place_purposes;

create policy place_purposes_create on public.place_purposes for INSERT to authenticated
with
  check (
    exists (
      select
        1
      from
        public.places p
      where
        p.id = place_purposes.place_id
        and p.created_by = (
          select
            auth.uid ()
        )
    )
  );

drop policy IF exists place_purposes_delete on public.place_purposes;

create policy place_purposes_delete on public.place_purposes for DELETE to authenticated using (
  exists (
    select
      1
    from
      public.places p
    where
      p.id = place_purposes.place_id
      and p.created_by = (
        select
          auth.uid ()
      )
  )
);

-- 6. FAVORITES
grant
    select
    ,
    DELETE on public.favorites to authenticated;

grant INSERT (user_id, place_id) on public.favorites to authenticated;

drop policy IF exists favorites_read on public.favorites;

create policy favorites_read on public.favorites for
select
    to authenticated using (
    user_id = (
    select
    auth.uid ()
    )
    );

drop policy IF exists favorites_create on public.favorites;

create policy favorites_create on public.favorites for INSERT to authenticated
with
  check (
    user_id = (
      select
        auth.uid ()
    )
    and exists (
      select
        1
      from
        public.places p
      where
        p.id = favorites.place_id
    )
  );

drop policy IF exists favorites_delete on public.favorites;

create policy favorites_delete on public.favorites for DELETE to authenticated using (
  user_id = (
    select
      auth.uid ()
  )
);

-- 7. BOOKMARKS
grant
    select
    ,
    DELETE on public.bookmarks to authenticated;

grant INSERT (user_id, place_id) on public.bookmarks to authenticated;

drop policy IF exists bookmarks_read on public.bookmarks;

create policy bookmarks_read on public.bookmarks for
select
    to authenticated using (
    user_id = (
    select
    auth.uid ()
    )
    );

drop policy IF exists bookmarks_create on public.bookmarks;

create policy bookmarks_create on public.bookmarks for INSERT to authenticated
with
  check (
    user_id = (
      select
        auth.uid ()
    )
    and exists (
      select
        1
      from
        public.places p
      where
        p.id = bookmarks.place_id
    )
  );

drop policy IF exists bookmarks_delete on public.bookmarks;

create policy bookmarks_delete on public.bookmarks for DELETE to authenticated using (
  user_id = (
    select
      auth.uid ()
  )
);

-- 8. PLACE IMAGES
grant
    select
    on public.place_images to anon,
    authenticated;

grant INSERT (
              id,
              place_id,
              storage_path,
              uploaded_by,
              sort_order
    ) on public.place_images to authenticated;

grant
    update (sort_order) on public.place_images to authenticated;

grant DELETE on public.place_images to authenticated;

drop policy IF exists place_images_read on public.place_images;

create policy place_images_read on public.place_images for
select
    to anon,
    authenticated using (
    exists (
    select
    1
    from
    public.places p
    where
    p.id = place_images.place_id
    )
    or uploaded_by = (
    select
    auth.uid ()
    )
    );

drop policy IF exists place_images_create on public.place_images;

create policy place_images_create on public.place_images for INSERT to authenticated
with
  check (
    uploaded_by = (
      select
        auth.uid ()
    )
    and exists (
      select
        1
      from
        public.places p
      where
        p.id = place_images.place_id
    )
    and split_part(storage_path, '/', 1) = (
      select
        auth.uid ()
    )::text
    and split_part(storage_path, '/', 2) = place_id::text
    and split_part(storage_path, '/', 3) <> ''
    and array_length(string_to_array(storage_path, '/'), 1) = 3
  );

drop policy IF exists place_images_update on public.place_images;

create policy place_images_update on public.place_images
for update
                                to authenticated using (
                                uploaded_by = (
                                select
                                auth.uid ()
                                )
                                )
    with
                                check (
                                uploaded_by = (
                                select
                                auth.uid ()
                                )
                                );

drop policy IF exists place_images_delete on public.place_images;

create policy place_images_delete on public.place_images for DELETE to authenticated using (
  uploaded_by = (
    select
      auth.uid ()
  )
);

-- 9. AUDIT LOGS
-- Intentionally no application policies or grants, including SELECT.
-- The audit trigger inserts as its owner.
-- service_role bypasses RLS and has administrative grants from file 01.
-- Never expose the service role key in the client application.
--
-- Policies are permissive and OR-combined. If additional policies already exist,
-- review them separately; these scripts only manage their own named policies.
commit;