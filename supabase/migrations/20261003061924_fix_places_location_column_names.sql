-- Drop the old signature explicitly (the argument types are part of the signature)
drop function if exists places_location(uuid[], uuid[]);
drop function if exists places_location(uuid[], uuid[], text);

create or replace function places_location(
    purpose_ids uuid[] default null,
    feature_ids uuid[] default null,
    search_text text default null
)
returns table (
    id uuid,
    name text,
    description text,
    category_id uuid,
    latitude double precision,
    longitude double precision,
    address text,
    postal_code text,
    city text,
    created_by uuid,
    status place_status,
    is_bookmark boolean,
    is_favorite boolean,
    created_at timestamptz,
    updated_at timestamptz
)
language sql
stable
set search_path = public, extensions
as $$
select
    p.id,
    p.name,
    p.description,
    p.category_id,
    extensions.st_y(p.location::extensions.geometry) as latitude,
    extensions.st_x(p.location::extensions.geometry) as longitude,
    p.address,
    p.postal_code,
    p.city,
    p.created_by,
    p.status,
    exists(
        select 1
        from bookmarks bm
        where bm.place_id = p.id
          and bm.user_id = auth.uid()
    ) as is_bookmark,
    exists(
        select 1
        from favorites fav
        where fav.place_id = p.id
          and fav.user_id = auth.uid()
    ) as is_favorite,
    p.created_at,
    p.updated_at
from places p
where
  -- Purposes: place matches ANY selected purpose
    (
        coalesce(cardinality(purpose_ids), 0) = 0
            or exists (
            select 1
            from place_purposes pp
            where pp.place_id = p.id
              and pp.purpose_id = any (purpose_ids)
        )
        )
  -- Features: place has ALL selected features
  and (
    coalesce(cardinality(feature_ids), 0) = 0
        or (
               select count(distinct pf.feature_id)
               from place_features pf
               where pf.place_id = p.id
                 and pf.feature_id = any (feature_ids)
           ) = cardinality(feature_ids)
    )
  -- Search: every word must match name, address, postal code, city or a feature
  and (
    nullif(btrim(search_text), '') is null
        or not exists (
        select 1
        from unnest(string_to_array(btrim(search_text), ' ')) as t(token)
        where t.token <> ''
          and not (
            p.name        ilike '%' || replace(replace(replace(t.token, '\', '\\'), '%', '\%'), '_', '\_') || '%'
               or p.address     ilike '%' || replace(replace(replace(t.token, '\', '\\'), '%', '\%'), '_', '\_') || '%'
               or p.postal_code ilike '%' || replace(replace(replace(t.token, '\', '\\'), '%', '\%'), '_', '\_') || '%'
               or p.city        ilike '%' || replace(replace(replace(t.token, '\', '\\'), '%', '\%'), '_', '\_') || '%'
               or exists (
                    select 1
                    from place_features pf
                    join features f on f.id = pf.feature_id
                    where pf.place_id = p.id
                      and (
                          f.name ilike '%' || replace(replace(replace(t.token, '\', '\\'), '%', '\%'), '_', '\_') || '%'
                       or f.slug ilike '%' || replace(replace(replace(t.token, '\', '\\'), '%', '\%'), '_', '\_') || '%'
                      )
               )
            )
    )
    );
$$;