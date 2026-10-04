create or replace function places_location()
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

    created_at timestamptz,
    updated_at timestamptz
)
language sql
stable
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

        p.created_at,
        p.updated_at
    from places p;
$$;
