begin;

select
    pg_catalog.set_config(
            'search_path',
            'public,' || pg_catalog.quote_ident(n.nspname) || ',pg_catalog',
            true
    )
from
    pg_catalog.pg_extension e
        join pg_catalog.pg_namespace n on n.oid = e.extnamespace
where
    e.extname = 'postgis';


-- ============================================================
-- Categories
-- ============================================================

insert into public.categories (
    id,
    name,
    slug
)
values
    (
        '0ab89bc0-8c52-5e82-bbb0-9f96475dfde5',
        'Bibliothek',
        'library'
    ),
    (
        '22222222-2222-2222-2222-222222222222',
        'Park',
        'park'
    ),
    (
        '7f664d3c-0e8c-5d73-8537-b49c365434ff',
        'Garten',
        'garden'
    ),
    (
        '017b0e72-33c1-5429-a9ab-99524ba8b6bc',
        'Promenade',
        'promenade'
    ),
    (
        '1c5d788b-031e-5a92-b954-c388d372b2b6',
        'Platz',
        'square'
    )
    on conflict do nothing;


-- ============================================================
-- Features
-- ============================================================

insert into public.features (
    id,
    slug,
    name,
    type,
    icon,
    sort_order
)
values
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
    ),
    (
        '0ca351d7-ecda-5297-af76-1c5c92fde99f',
        'seating',
        'Sitzplätze',
        'boolean',
        'chair.fill',
        4
    ),
    (
        '4e3ee537-0f95-58ae-9de3-2cbc7f94dc26',
        'weather-protection',
        'Wetterschutz',
        'boolean',
        'umbrella.fill',
        5
    ),
    (
        '53afada3-e012-5bfd-af12-beb1670068f8',
        'toilets',
        'WC',
        'boolean',
        'toilet.fill',
        6
    ),
    (
        'ac75a29b-a228-55c7-8220-d55211d9ef2a',
        'wheelchair-accessible',
        'Barrierearm',
        'boolean',
        'figure.roll',
        7
    ),
    (
        '4d441d69-5fae-5713-9ff4-2ff3c84017e2',
        'green-space',
        'Im Grünen',
        'boolean',
        'leaf.fill',
        8
    ),
    (
        '9db62fde-1e31-5fca-b412-42a368d047de',
        'view',
        'Aussicht',
        'boolean',
        'binoculars.fill',
        9
    )
    on conflict do nothing;


-- ============================================================
-- Purposes
-- ============================================================

insert into public.purposes (
    name,
    slug,
    sort_order
)
values
    ('Study', 'study', 1),
    ('Work remotely', 'work-remotely', 2),
    ('Meet friends', 'meet-friends', 3),
    ('Read', 'read', 4),
    ('Relax', 'relax', 5),
    ('Eat', 'eat', 6),
    ('Go on a date', 'go-on-a-date', 7),
    ('Wait', 'wait', 8),
    ('Walk', 'walk', 9)
    on conflict do nothing;


-- ============================================================
-- Places
-- ============================================================

insert into public.places (
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
select
    place_data.id,
    place_data.name,
    place_data.description,
    category.id,
    ST_SetSRID(
            ST_MakePoint(
                    place_data.longitude,
                    place_data.latitude
            ),
            4326
    )::geography,
    place_data.address,
    place_data.postal_code,
    place_data.city,
    'approved'
from (
         values

             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'Bibliothek Hauptpost',
                 'Zentrale Bibliothek direkt beim Hauptbahnhof St. Gallen mit Arbeitsplätzen, WLAN und ruhigen Bereichen zum Lesen und Lernen.',
                 'library',
                 9.370273,
                 47.422756,
                 'Gutenbergstrasse 2',
                 '9000',
                 'St. Gallen'
             ),

             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'Stadtbibliothek Katharinen',
                 'Stadtbibliothek in der St. Galler Altstadt. Geeignet zum Lesen, Lernen und für ruhiges Arbeiten.',
                 'library',
                 9.377090,
                 47.426970,
                 'Katharinengasse 11',
                 '9000',
                 'St. Gallen'
             ),

             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'Drei Weieren',
                 'Naherholungsgebiet oberhalb von St. Gallen mit Weihern, Liegewiesen, Sitzmöglichkeiten und Aussicht über die Stadt.',
                 'park',
                 9.387210,
                 47.421420,
                 'Bitzistrasse 65',
                 '9011',
                 'St. Gallen'
             ),

             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'Stadtpark',
                 'Zentral gelegener öffentlicher Park im Museumsquartier mit Grünflächen und Sitzmöglichkeiten.',
                 'park',
                 9.383900,
                 47.429300,
                 null,
                 '9000',
                 'St. Gallen'
             ),

             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'Botanischer Garten St. Gallen',
                 'Öffentlich zugänglicher botanischer Garten mit zahlreichen Pflanzenarten, Gewächshäusern und ruhigen Bereichen zum Spazieren und Verweilen.',
                 'garden',
                 9.407020,
                 47.439860,
                 'Stephanshornstrasse 4',
                 '9016',
                 'St. Gallen'
             ),

             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'Mülenenschlucht',
                 'Historischer Fussweg durch die Mülenenschlucht zwischen der Altstadt und St. Georgen. Die Strecke führt entlang der Steinach steil bergauf.',
                 'promenade',
                 9.377835,
                 47.420694,
                 null,
                 '9000',
                 'St. Gallen'
             ),

             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'Klosterplatz',
                 'Öffentlicher Platz im historischen Stiftsbezirk von St. Gallen und zentraler Treffpunkt in der Altstadt.',
                 'square',
                 9.377900,
                 47.423400,
                 'Klosterhof',
                 '9000',
                 'St. Gallen'
             )

     ) as place_data(
                     id,
                     name,
                     description,
                     category_slug,
                     longitude,
                     latitude,
                     address,
                     postal_code,
                     city
    )
         join public.categories category
              on category.slug = place_data.category_slug
    on conflict do nothing;


-- ============================================================
-- Place Features
-- ============================================================
--
-- boolean_value:
--     true / false for boolean features
--
-- rating_value:
--     1 - 5 for rating features
--
-- quietness:
--     1 = laut
--     5 = sehr ruhig
--
-- ============================================================

insert into public.place_features (
    place_id,
    feature_id,
    boolean_value,
    rating_value
)
select
    feature_data.place_id,
    feature.id,
    feature_data.boolean_value,
    feature_data.rating_value
from (
         values

             -- ----------------------------------------------------
             -- Bibliothek Hauptpost
             -- ----------------------------------------------------

             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'wifi',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'power-outlets',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'quietness',
                 null,
                 4
             ),
             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'seating',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'weather-protection',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'toilets',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'wheelchair-accessible',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'green-space',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000001'::uuid,
                 'view',
                 false,
                 null::integer
             ),


             -- ----------------------------------------------------
             -- Stadtbibliothek Katharinen
             -- ----------------------------------------------------

             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'wifi',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'power-outlets',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'quietness',
                 null,
                 4
             ),
             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'seating',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'weather-protection',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'toilets',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'wheelchair-accessible',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'green-space',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000002'::uuid,
                 'view',
                 false,
                 null::integer
             ),


             -- ----------------------------------------------------
             -- Drei Weieren
             -- ----------------------------------------------------

             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'wifi',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'power-outlets',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'quietness',
                 null,
                 3
             ),
             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'seating',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'weather-protection',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'toilets',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'wheelchair-accessible',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'green-space',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000003'::uuid,
                 'view',
                 true,
                 null::integer
             ),


             -- ----------------------------------------------------
             -- Stadtpark
             -- ----------------------------------------------------

             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'wifi',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'power-outlets',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'quietness',
                 null,
                 3
             ),
             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'seating',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'weather-protection',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'toilets',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'wheelchair-accessible',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'green-space',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000004'::uuid,
                 'view',
                 false,
                 null::integer
             ),


             -- ----------------------------------------------------
             -- Botanischer Garten
             -- ----------------------------------------------------

             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'wifi',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'power-outlets',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'quietness',
                 null,
                 5
             ),
             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'seating',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'weather-protection',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'toilets',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'wheelchair-accessible',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'green-space',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000005'::uuid,
                 'view',
                 false,
                 null::integer
             ),


             -- ----------------------------------------------------
             -- Mülenenschlucht
             -- ----------------------------------------------------

             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'wifi',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'power-outlets',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'quietness',
                 null,
                 4
             ),
             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'seating',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'weather-protection',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'toilets',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'wheelchair-accessible',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'green-space',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000006'::uuid,
                 'view',
                 true,
                 null::integer
             ),


             -- ----------------------------------------------------
             -- Klosterplatz
             -- ----------------------------------------------------

             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'wifi',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'power-outlets',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'quietness',
                 null,
                 2
             ),
             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'seating',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'weather-protection',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'toilets',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'wheelchair-accessible',
                 true,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'green-space',
                 false,
                 null::integer
             ),
             (
                 '10000000-0000-0000-0000-000000000007'::uuid,
                 'view',
                 false,
                 null::integer
             )

     ) as feature_data(
                       place_id,
                       feature_slug,
                       boolean_value,
                       rating_value
    )
         join public.features feature
              on feature.slug = feature_data.feature_slug
    on conflict do nothing;


-- ============================================================
-- Place Purposes
-- ============================================================

insert into public.place_purposes (
    place_id,
    purpose_id
)
select
    purpose_data.place_id,
    purpose.id
from (
         values

             -- Bibliothek Hauptpost
             ('10000000-0000-0000-0000-000000000001'::uuid, 'study'),
             ('10000000-0000-0000-0000-000000000001'::uuid, 'work-remotely'),
             ('10000000-0000-0000-0000-000000000001'::uuid, 'read'),
             ('10000000-0000-0000-0000-000000000001'::uuid, 'wait'),

             -- Stadtbibliothek Katharinen
             ('10000000-0000-0000-0000-000000000002'::uuid, 'study'),
             ('10000000-0000-0000-0000-000000000002'::uuid, 'read'),
             ('10000000-0000-0000-0000-000000000002'::uuid, 'meet-friends'),

             -- Drei Weieren
             ('10000000-0000-0000-0000-000000000003'::uuid, 'meet-friends'),
             ('10000000-0000-0000-0000-000000000003'::uuid, 'relax'),
             ('10000000-0000-0000-0000-000000000003'::uuid, 'eat'),
             ('10000000-0000-0000-0000-000000000003'::uuid, 'go-on-a-date'),
             ('10000000-0000-0000-0000-000000000003'::uuid, 'walk'),

             -- Stadtpark
             ('10000000-0000-0000-0000-000000000004'::uuid, 'meet-friends'),
             ('10000000-0000-0000-0000-000000000004'::uuid, 'read'),
             ('10000000-0000-0000-0000-000000000004'::uuid, 'relax'),
             ('10000000-0000-0000-0000-000000000004'::uuid, 'wait'),
             ('10000000-0000-0000-0000-000000000004'::uuid, 'walk'),

             -- Botanischer Garten
             ('10000000-0000-0000-0000-000000000005'::uuid, 'read'),
             ('10000000-0000-0000-0000-000000000005'::uuid, 'relax'),
             ('10000000-0000-0000-0000-000000000005'::uuid, 'go-on-a-date'),
             ('10000000-0000-0000-0000-000000000005'::uuid, 'walk'),

             -- Mülenenschlucht
             ('10000000-0000-0000-0000-000000000006'::uuid, 'relax'),
             ('10000000-0000-0000-0000-000000000006'::uuid, 'walk'),

             -- Klosterplatz
             ('10000000-0000-0000-0000-000000000007'::uuid, 'meet-friends'),
             ('10000000-0000-0000-0000-000000000007'::uuid, 'wait'),
             ('10000000-0000-0000-0000-000000000007'::uuid, 'walk')

     ) as purpose_data(
                       place_id,
                       purpose_slug
    )
         join public.purposes purpose
              on purpose.slug = purpose_data.purpose_slug
    on conflict do nothing;


commit;