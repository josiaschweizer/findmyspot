-- Categories
INSERT INTO public.categories (
    id,
    name,
    slug
)
VALUES
    (
        '11111111-1111-1111-1111-111111111111',
        'Café',
        'cafe'
    ),
    (
        '22222222-2222-2222-2222-222222222222',
        'Park',
        'park'
    ),
    (
        '33333333-3333-3333-3333-333333333333',
        'Arbeitsplatz',
        'workspace'
    );


-- Features
INSERT INTO public.features (
    id,
    slug,
    name,
    type,
    icon,
    sort_order
)
VALUES
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
        'wifi',
        'WLAN',
        'boolean',
        'wifi',
        1
    ),
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
        'power-outlets',
        'Steckdosen',
        'boolean',
        'bolt.fill',
        2
    ),
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
        'quietness',
        'Ruhe',
        'rating',
        'speaker.slash.fill',
        3
    );


-- Places
INSERT INTO public.places (
    id,
    name,
    description,
    category_id,
    location,
    address,
    postal_code,
    city,
    status
)
VALUES
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        'Kaffeehaus',
        'Gemütliches Café in St. Gallen mit WLAN und Steckdosen.',
        '11111111-1111-1111-1111-111111111111',
        extensions.st_point(9.380000, 47.420000)::extensions.geography,
        'Linsebühlstrasse 77',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        'Drei Weieren',
        'Öffentlicher Erholungsort oberhalb der Stadt St. Gallen mit viel Platz und ruhiger Umgebung.',
        '22222222-2222-2222-2222-222222222222',
        extensions.st_point(9.376000, 47.417000)::extensions.geography,
        NULL,
        '9000',
        'St. Gallen',
        'approved'
    );


-- Place Features
INSERT INTO public.place_features (
    place_id,
    feature_id,
    boolean_value,
    rating_value
)
VALUES
    -- Kaffeehaus
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
        TRUE,
        NULL
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
        TRUE,
        NULL
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
        NULL,
        3
    ),

    -- Drei Weieren
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
        FALSE,
        NULL
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
        FALSE,
        NULL
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
        NULL,
        5
    );

-- features
INSERT INTO purposes (name, slug, sort_order)
VALUES
    ('Study', 'study', 1),
    ('Work remotely', 'work-remotely', 2),
    ('Meet friends', 'meet-friends', 3),
    ('Read', 'read', 4),
    ('Relax', 'relax', 5),
    ('Have a coffee', 'have-a-coffee', 6),
    ('Eat', 'eat', 7),
    ('Go on a date', 'go-on-a-date', 8),
    ('Hold a meeting', 'hold-a-meeting', 9),
    ('Play board games', 'play-board-games', 10);