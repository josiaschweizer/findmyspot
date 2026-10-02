begin;

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

-- Categories
insert into
    public.categories (id, name, slug)
values
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
    ),
    (
        '0ab89bc0-8c52-5e82-bbb0-9f96475dfde5',
        'Bibliothek',
        'library'
    ),
    (
        '1c5d788b-031e-5a92-b954-c388d372b2b6',
        'Platz',
        'square'
    ),
    (
        'a40d4300-be07-5f9f-bb30-4c848cbaffe7',
        'Unterstand',
        'shelter'
    ),
    (
        '6ec522e0-e040-5b07-aba3-c81d40c2aff9',
        'Aussichtspunkt',
        'viewpoint'
    ),
    (
        'c9b958b1-f33e-560a-b56b-825a2b61a2b6',
        'Uferplatz',
        'riverside'
    ),
    (
        '7f664d3c-0e8c-5d73-8537-b49c365434ff',
        'Garten',
        'garden'
    ),
    (
        'a29a0de7-3edd-589d-9cfc-c4950fa44bcb',
        'Picknickplatz',
        'picnic'
    ),
    (
        '19d4fdc1-6842-554a-8712-668cea874b81',
        'Waldrastplatz',
        'forest'
    ),
    (
        'deb118cb-3291-5c11-baba-6d0c7b5efeff',
        'Innenhof',
        'courtyard'
    ),
    (
        '017b0e72-33c1-5429-a9ab-99524ba8b6bc',
        'Promenade',
        'promenade'
    )
    on conflict do nothing;

-- Features
insert into
    public.features (id, slug, name, type, icon, sort_order)
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

-- Purposes
insert into
    public.purposes (name, slug, sort_order)
values
    ('Study', 'study', 1),
    ('Work remotely', 'work-remotely', 2),
    ('Meet friends', 'meet-friends', 3),
    ('Read', 'read', 4),
    ('Relax', 'relax', 5),
    ('Have a coffee', 'have-a-coffee', 6),
    ('Eat', 'eat', 7),
    ('Go on a date', 'go-on-a-date', 8),
    ('Hold a meeting', 'hold-a-meeting', 9),
    ('Play board games', 'play-board-games', 10),
    ('Wait', 'wait', 11),
    ('Walk', 'walk', 12)
    on conflict do nothing;

-- Places
insert into
    public.places (
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
values
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        'Kaffeehaus',
        'Gemütliches Café in St. Gallen mit WLAN und Steckdosen.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'cafe'
        ),
        ST_SetSRID (ST_MakePoint (9.38, 47.42), 4326)::geography,
        'Linsebühlstrasse 77',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        'Drei Weieren',
        'Öffentlicher Erholungsort oberhalb der Stadt St. Gallen mit viel Platz und ruhiger Umgebung.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.376, 47.417), 4326)::geography,
        null,
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        '[Demo] Leseraum St. Gallen 01',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (9.3644, 47.4183), 4326)::geography,
        'Demo-Bereich 01',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        '[Demo] Parkwiese St. Gallen 01',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.3685, 47.41843), 4326)::geography,
        'Demo-Bereich 02',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        '[Demo] Quartierplatz St. Gallen 01',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (9.3726, 47.41856), 4326)::geography,
        'Demo-Bereich 03',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        '[Demo] Überdachter Treffpunkt St. Gallen 01',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (9.3767, 47.4183), 4326)::geography,
        'Demo-Bereich 04',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        '[Demo] Aussichtsbank St. Gallen 01',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (9.3808, 47.41843), 4326)::geography,
        'Demo-Bereich 05',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        '[Demo] Uferpause St. Gallen 01',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (9.3849, 47.41856), 4326)::geography,
        'Demo-Bereich 06',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        '[Demo] Lesegarten St. Gallen 01',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (9.389, 47.4183), 4326)::geography,
        'Demo-Bereich 07',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        '[Demo] Öffentlicher Arbeitsbereich St. Gallen 01',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (9.3931, 47.41843), 4326)::geography,
        'Demo-Bereich 08',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        '[Demo] Picknickplatz St. Gallen 01',
        'Fiktiver Demo-Ort. Eine Tischgruppe für mitgebrachte Verpflegung und gemeinsame Pausen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'picnic'
        ),
        ST_SetSRID (ST_MakePoint (9.3644, 47.42166), 4326)::geography,
        'Demo-Bereich 09',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        '[Demo] Waldrandbank St. Gallen 01',
        'Fiktiver Demo-Ort. Ein stiller Rastpunkt am beispielhaften Übergang zum Wald. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'forest'
        ),
        ST_SetSRID (ST_MakePoint (9.3685, 47.4214), 4326)::geography,
        'Demo-Bereich 10',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        '[Demo] Innenhof St. Gallen 01',
        'Fiktiver Demo-Ort. Ein geschützter Hof mit Platz für Gespräche und eine kurze Auszeit. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'courtyard'
        ),
        ST_SetSRID (ST_MakePoint (9.3726, 47.42153), 4326)::geography,
        'Demo-Bereich 11',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        '[Demo] Spazierpunkt St. Gallen 01',
        'Fiktiver Demo-Ort. Ein Haltepunkt entlang einer beispielhaften Spazierstrecke. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'promenade'
        ),
        ST_SetSRID (ST_MakePoint (9.3767, 47.42166), 4326)::geography,
        'Demo-Bereich 12',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        '[Demo] Leseraum St. Gallen 02',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (9.3808, 47.4214), 4326)::geography,
        'Demo-Bereich 13',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        '[Demo] Parkwiese St. Gallen 02',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.3849, 47.42153), 4326)::geography,
        'Demo-Bereich 14',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        '[Demo] Quartierplatz St. Gallen 02',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (9.389, 47.42166), 4326)::geography,
        'Demo-Bereich 15',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        '[Demo] Überdachter Treffpunkt St. Gallen 02',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (9.3931, 47.4214), 4326)::geography,
        'Demo-Bereich 16',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '0d61dfc9-ed58-5ad8-90ed-be71efc44660',
        '[Demo] Aussichtsbank St. Gallen 02',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (9.3644, 47.42463), 4326)::geography,
        'Demo-Bereich 17',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        '[Demo] Uferpause St. Gallen 02',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (9.3685, 47.42476), 4326)::geography,
        'Demo-Bereich 18',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        '[Demo] Lesegarten St. Gallen 02',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (9.3726, 47.4245), 4326)::geography,
        'Demo-Bereich 19',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        '[Demo] Öffentlicher Arbeitsbereich St. Gallen 02',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (9.3767, 47.42463), 4326)::geography,
        'Demo-Bereich 20',
        '9000',
        'St. Gallen',
        'pending'
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        '[Demo] Picknickplatz St. Gallen 02',
        'Fiktiver Demo-Ort. Eine Tischgruppe für mitgebrachte Verpflegung und gemeinsame Pausen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'picnic'
        ),
        ST_SetSRID (ST_MakePoint (9.3808, 47.42476), 4326)::geography,
        'Demo-Bereich 21',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        '[Demo] Waldrandbank St. Gallen 02',
        'Fiktiver Demo-Ort. Ein stiller Rastpunkt am beispielhaften Übergang zum Wald. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'forest'
        ),
        ST_SetSRID (ST_MakePoint (9.3849, 47.4245), 4326)::geography,
        'Demo-Bereich 22',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        '[Demo] Innenhof St. Gallen 02',
        'Fiktiver Demo-Ort. Ein geschützter Hof mit Platz für Gespräche und eine kurze Auszeit. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'courtyard'
        ),
        ST_SetSRID (ST_MakePoint (9.389, 47.42463), 4326)::geography,
        'Demo-Bereich 23',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        '[Demo] Spazierpunkt St. Gallen 02',
        'Fiktiver Demo-Ort. Ein Haltepunkt entlang einer beispielhaften Spazierstrecke. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'promenade'
        ),
        ST_SetSRID (ST_MakePoint (9.3931, 47.42476), 4326)::geography,
        'Demo-Bereich 24',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        '[Demo] Leseraum St. Gallen 03',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (9.3644, 47.4276), 4326)::geography,
        'Demo-Bereich 25',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        '[Demo] Parkwiese St. Gallen 03',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.3685, 47.42773), 4326)::geography,
        'Demo-Bereich 26',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        '[Demo] Quartierplatz St. Gallen 03',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (9.3726, 47.42786), 4326)::geography,
        'Demo-Bereich 27',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        '[Demo] Überdachter Treffpunkt St. Gallen 03',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (9.3767, 47.4276), 4326)::geography,
        'Demo-Bereich 28',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        '[Demo] Aussichtsbank St. Gallen 03',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (9.3808, 47.42773), 4326)::geography,
        'Demo-Bereich 29',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        '[Demo] Uferpause St. Gallen 03',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (9.3849, 47.42786), 4326)::geography,
        'Demo-Bereich 30',
        '9000',
        'St. Gallen',
        'rejected'
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        '[Demo] Lesegarten St. Gallen 03',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (9.389, 47.4276), 4326)::geography,
        'Demo-Bereich 31',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        '[Demo] Öffentlicher Arbeitsbereich St. Gallen 03',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (9.3931, 47.42773), 4326)::geography,
        'Demo-Bereich 32',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        '[Demo] Picknickplatz St. Gallen 03',
        'Fiktiver Demo-Ort. Eine Tischgruppe für mitgebrachte Verpflegung und gemeinsame Pausen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'picnic'
        ),
        ST_SetSRID (ST_MakePoint (9.3644, 47.43096), 4326)::geography,
        'Demo-Bereich 33',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '87bab896-a8c9-523c-8c94-5cc98cbedae6',
        '[Demo] Waldrandbank St. Gallen 03',
        'Fiktiver Demo-Ort. Ein stiller Rastpunkt am beispielhaften Übergang zum Wald. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'forest'
        ),
        ST_SetSRID (ST_MakePoint (9.3685, 47.4307), 4326)::geography,
        'Demo-Bereich 34',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        '[Demo] Innenhof St. Gallen 03',
        'Fiktiver Demo-Ort. Ein geschützter Hof mit Platz für Gespräche und eine kurze Auszeit. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'courtyard'
        ),
        ST_SetSRID (ST_MakePoint (9.3726, 47.43083), 4326)::geography,
        'Demo-Bereich 35',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        '[Demo] Spazierpunkt St. Gallen 03',
        'Fiktiver Demo-Ort. Ein Haltepunkt entlang einer beispielhaften Spazierstrecke. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'promenade'
        ),
        ST_SetSRID (ST_MakePoint (9.3767, 47.43096), 4326)::geography,
        'Demo-Bereich 36',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        '[Demo] Leseraum St. Gallen 04',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (9.3808, 47.4307), 4326)::geography,
        'Demo-Bereich 37',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        '[Demo] Parkwiese St. Gallen 04',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.3849, 47.43083), 4326)::geography,
        'Demo-Bereich 38',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        '[Demo] Quartierplatz St. Gallen 04',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (9.389, 47.43096), 4326)::geography,
        'Demo-Bereich 39',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        '[Demo] Überdachter Treffpunkt St. Gallen 04',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (9.3931, 47.4307), 4326)::geography,
        'Demo-Bereich 40',
        '9000',
        'St. Gallen',
        'pending'
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        '[Demo] Aussichtsbank St. Gallen 04',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (9.3644, 47.43393), 4326)::geography,
        'Demo-Bereich 41',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        '[Demo] Uferpause St. Gallen 04',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (9.3685, 47.43406), 4326)::geography,
        'Demo-Bereich 42',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        '[Demo] Lesegarten St. Gallen 04',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (9.3726, 47.4338), 4326)::geography,
        'Demo-Bereich 43',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        '[Demo] Öffentlicher Arbeitsbereich St. Gallen 04',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (9.3767, 47.43393), 4326)::geography,
        'Demo-Bereich 44',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        '[Demo] Picknickplatz St. Gallen 04',
        'Fiktiver Demo-Ort. Eine Tischgruppe für mitgebrachte Verpflegung und gemeinsame Pausen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'picnic'
        ),
        ST_SetSRID (ST_MakePoint (9.3808, 47.43406), 4326)::geography,
        'Demo-Bereich 45',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        '[Demo] Waldrandbank St. Gallen 04',
        'Fiktiver Demo-Ort. Ein stiller Rastpunkt am beispielhaften Übergang zum Wald. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'forest'
        ),
        ST_SetSRID (ST_MakePoint (9.3849, 47.4338), 4326)::geography,
        'Demo-Bereich 46',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        '[Demo] Innenhof St. Gallen 04',
        'Fiktiver Demo-Ort. Ein geschützter Hof mit Platz für Gespräche und eine kurze Auszeit. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'courtyard'
        ),
        ST_SetSRID (ST_MakePoint (9.389, 47.43393), 4326)::geography,
        'Demo-Bereich 47',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        '[Demo] Spazierpunkt St. Gallen 04',
        'Fiktiver Demo-Ort. Ein Haltepunkt entlang einer beispielhaften Spazierstrecke. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'promenade'
        ),
        ST_SetSRID (ST_MakePoint (9.3931, 47.43406), 4326)::geography,
        'Demo-Bereich 48',
        '9000',
        'St. Gallen',
        'approved'
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        '[Demo] Leseraum Gossau 01',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (9.2396, 47.4093), 4326)::geography,
        'Demo-Bereich 01',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        '[Demo] Parkwiese Gossau 01',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.2437, 47.40943), 4326)::geography,
        'Demo-Bereich 02',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        'f00c95f0-9212-5166-9598-01074bc9bc99',
        '[Demo] Quartierplatz Gossau 01',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (9.2478, 47.40956), 4326)::geography,
        'Demo-Bereich 03',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        '[Demo] Überdachter Treffpunkt Gossau 01',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (9.2519, 47.4093), 4326)::geography,
        'Demo-Bereich 04',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        '[Demo] Aussichtsbank Gossau 01',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (9.256, 47.40943), 4326)::geography,
        'Demo-Bereich 05',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        '[Demo] Uferpause Gossau 01',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (9.2601, 47.40956), 4326)::geography,
        'Demo-Bereich 06',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        '[Demo] Lesegarten Gossau 01',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (9.2642, 47.4093), 4326)::geography,
        'Demo-Bereich 07',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        '[Demo] Öffentlicher Arbeitsbereich Gossau 01',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (9.2683, 47.40943), 4326)::geography,
        'Demo-Bereich 08',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        '[Demo] Picknickplatz Gossau 01',
        'Fiktiver Demo-Ort. Eine Tischgruppe für mitgebrachte Verpflegung und gemeinsame Pausen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'picnic'
        ),
        ST_SetSRID (ST_MakePoint (9.2396, 47.41266), 4326)::geography,
        'Demo-Bereich 09',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        '[Demo] Waldrandbank Gossau 01',
        'Fiktiver Demo-Ort. Ein stiller Rastpunkt am beispielhaften Übergang zum Wald. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'forest'
        ),
        ST_SetSRID (ST_MakePoint (9.2437, 47.4124), 4326)::geography,
        'Demo-Bereich 10',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        '[Demo] Innenhof Gossau 01',
        'Fiktiver Demo-Ort. Ein geschützter Hof mit Platz für Gespräche und eine kurze Auszeit. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'courtyard'
        ),
        ST_SetSRID (ST_MakePoint (9.2478, 47.41253), 4326)::geography,
        'Demo-Bereich 11',
        '9200',
        'Gossau',
        'approved'
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        '[Demo] Spazierpunkt Gossau 01',
        'Fiktiver Demo-Ort. Ein Haltepunkt entlang einer beispielhaften Spazierstrecke. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'promenade'
        ),
        ST_SetSRID (ST_MakePoint (9.2519, 47.41266), 4326)::geography,
        'Demo-Bereich 12',
        '9200',
        'Gossau',
        'pending'
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        '[Demo] Leseraum Herisau 01',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (9.2669, 47.3798), 4326)::geography,
        'Demo-Bereich 01',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        '[Demo] Parkwiese Herisau 01',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.271, 47.37993), 4326)::geography,
        'Demo-Bereich 02',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        '[Demo] Quartierplatz Herisau 01',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (9.2751, 47.38006), 4326)::geography,
        'Demo-Bereich 03',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        '[Demo] Überdachter Treffpunkt Herisau 01',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (9.2792, 47.3798), 4326)::geography,
        'Demo-Bereich 04',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        '[Demo] Aussichtsbank Herisau 01',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (9.2833, 47.37993), 4326)::geography,
        'Demo-Bereich 05',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        '[Demo] Uferpause Herisau 01',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (9.2874, 47.38006), 4326)::geography,
        'Demo-Bereich 06',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        '[Demo] Lesegarten Herisau 01',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (9.2915, 47.3798), 4326)::geography,
        'Demo-Bereich 07',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        'cc1a2333-15f4-5d04-b8fb-d81ec1e4f739',
        '[Demo] Öffentlicher Arbeitsbereich Herisau 01',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (9.2956, 47.37993), 4326)::geography,
        'Demo-Bereich 08',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        '[Demo] Picknickplatz Herisau 01',
        'Fiktiver Demo-Ort. Eine Tischgruppe für mitgebrachte Verpflegung und gemeinsame Pausen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'picnic'
        ),
        ST_SetSRID (ST_MakePoint (9.2669, 47.38316), 4326)::geography,
        'Demo-Bereich 09',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        '[Demo] Waldrandbank Herisau 01',
        'Fiktiver Demo-Ort. Ein stiller Rastpunkt am beispielhaften Übergang zum Wald. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'forest'
        ),
        ST_SetSRID (ST_MakePoint (9.271, 47.3829), 4326)::geography,
        'Demo-Bereich 10',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        '[Demo] Innenhof Herisau 01',
        'Fiktiver Demo-Ort. Ein geschützter Hof mit Platz für Gespräche und eine kurze Auszeit. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'courtyard'
        ),
        ST_SetSRID (ST_MakePoint (9.2751, 47.38303), 4326)::geography,
        'Demo-Bereich 11',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        '[Demo] Spazierpunkt Herisau 01',
        'Fiktiver Demo-Ort. Ein Haltepunkt entlang einer beispielhaften Spazierstrecke. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'promenade'
        ),
        ST_SetSRID (ST_MakePoint (9.2792, 47.38316), 4326)::geography,
        'Demo-Bereich 12',
        '9100',
        'Herisau',
        'approved'
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        '[Demo] Leseraum Rorschach 01',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (9.4807, 47.4718), 4326)::geography,
        'Demo-Bereich 01',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        '[Demo] Parkwiese Rorschach 01',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.4848, 47.47193), 4326)::geography,
        'Demo-Bereich 02',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        '[Demo] Quartierplatz Rorschach 01',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (9.4889, 47.47206), 4326)::geography,
        'Demo-Bereich 03',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        '[Demo] Überdachter Treffpunkt Rorschach 01',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (9.493, 47.4718), 4326)::geography,
        'Demo-Bereich 04',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        '[Demo] Aussichtsbank Rorschach 01',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (9.4971, 47.47193), 4326)::geography,
        'Demo-Bereich 05',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        '[Demo] Uferpause Rorschach 01',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (9.5012, 47.47206), 4326)::geography,
        'Demo-Bereich 06',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        '[Demo] Lesegarten Rorschach 01',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (9.5053, 47.4718), 4326)::geography,
        'Demo-Bereich 07',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        '[Demo] Öffentlicher Arbeitsbereich Rorschach 01',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (9.5094, 47.47193), 4326)::geography,
        'Demo-Bereich 08',
        '9400',
        'Rorschach',
        'pending'
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        '[Demo] Picknickplatz Rorschach 01',
        'Fiktiver Demo-Ort. Eine Tischgruppe für mitgebrachte Verpflegung und gemeinsame Pausen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'picnic'
        ),
        ST_SetSRID (ST_MakePoint (9.4807, 47.47516), 4326)::geography,
        'Demo-Bereich 09',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        '[Demo] Waldrandbank Rorschach 01',
        'Fiktiver Demo-Ort. Ein stiller Rastpunkt am beispielhaften Übergang zum Wald. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'forest'
        ),
        ST_SetSRID (ST_MakePoint (9.4848, 47.4749), 4326)::geography,
        'Demo-Bereich 10',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        '[Demo] Innenhof Rorschach 01',
        'Fiktiver Demo-Ort. Ein geschützter Hof mit Platz für Gespräche und eine kurze Auszeit. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'courtyard'
        ),
        ST_SetSRID (ST_MakePoint (9.4889, 47.47503), 4326)::geography,
        'Demo-Bereich 11',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        '[Demo] Spazierpunkt Rorschach 01',
        'Fiktiver Demo-Ort. Ein Haltepunkt entlang einer beispielhaften Spazierstrecke. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'promenade'
        ),
        ST_SetSRID (ST_MakePoint (9.493, 47.47516), 4326)::geography,
        'Demo-Bereich 12',
        '9400',
        'Rorschach',
        'approved'
    ),
    (
        '9c5fd532-4173-5e94-8bb5-83ba863ee64a',
        '[Demo] Leseraum Wil 01',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (9.0327, 47.4562), 4326)::geography,
        'Demo-Bereich 01',
        '9500',
        'Wil',
        'approved'
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        '[Demo] Parkwiese Wil 01',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (9.0368, 47.45633), 4326)::geography,
        'Demo-Bereich 02',
        '9500',
        'Wil',
        'approved'
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        '[Demo] Quartierplatz Wil 01',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (9.0409, 47.45646), 4326)::geography,
        'Demo-Bereich 03',
        '9500',
        'Wil',
        'approved'
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        '[Demo] Überdachter Treffpunkt Wil 01',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (9.045, 47.4562), 4326)::geography,
        'Demo-Bereich 04',
        '9500',
        'Wil',
        'approved'
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        '[Demo] Aussichtsbank Wil 01',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (9.0491, 47.45633), 4326)::geography,
        'Demo-Bereich 05',
        '9500',
        'Wil',
        'approved'
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        '[Demo] Uferpause Wil 01',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (9.0532, 47.45646), 4326)::geography,
        'Demo-Bereich 06',
        '9500',
        'Wil',
        'rejected'
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        '[Demo] Lesegarten Wil 01',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (9.0573, 47.4562), 4326)::geography,
        'Demo-Bereich 07',
        '9500',
        'Wil',
        'approved'
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        '[Demo] Öffentlicher Arbeitsbereich Wil 01',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (9.0614, 47.45633), 4326)::geography,
        'Demo-Bereich 08',
        '9500',
        'Wil',
        'approved'
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        '[Demo] Picknickplatz Wil 01',
        'Fiktiver Demo-Ort. Eine Tischgruppe für mitgebrachte Verpflegung und gemeinsame Pausen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'picnic'
        ),
        ST_SetSRID (ST_MakePoint (9.0327, 47.45956), 4326)::geography,
        'Demo-Bereich 09',
        '9500',
        'Wil',
        'approved'
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        '[Demo] Waldrandbank Wil 01',
        'Fiktiver Demo-Ort. Ein stiller Rastpunkt am beispielhaften Übergang zum Wald. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'forest'
        ),
        ST_SetSRID (ST_MakePoint (9.0368, 47.4593), 4326)::geography,
        'Demo-Bereich 10',
        '9500',
        'Wil',
        'approved'
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        '[Demo] Innenhof Wil 01',
        'Fiktiver Demo-Ort. Ein geschützter Hof mit Platz für Gespräche und eine kurze Auszeit. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'courtyard'
        ),
        ST_SetSRID (ST_MakePoint (9.0409, 47.45943), 4326)::geography,
        'Demo-Bereich 11',
        '9500',
        'Wil',
        'approved'
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        '[Demo] Spazierpunkt Wil 01',
        'Fiktiver Demo-Ort. Ein Haltepunkt entlang einer beispielhaften Spazierstrecke. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'promenade'
        ),
        ST_SetSRID (ST_MakePoint (9.045, 47.45956), 4326)::geography,
        'Demo-Bereich 12',
        '9500',
        'Wil',
        'approved'
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        '[Demo] Leseraum Winterthur 01',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (8.7117, 47.4928), 4326)::geography,
        'Demo-Bereich 01',
        '8400',
        'Winterthur',
        'approved'
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        '[Demo] Parkwiese Winterthur 01',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (8.7158, 47.49293), 4326)::geography,
        'Demo-Bereich 02',
        '8400',
        'Winterthur',
        'approved'
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        '[Demo] Quartierplatz Winterthur 01',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (8.7199, 47.49306), 4326)::geography,
        'Demo-Bereich 03',
        '8400',
        'Winterthur',
        'approved'
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        '[Demo] Überdachter Treffpunkt Winterthur 01',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (8.724, 47.4928), 4326)::geography,
        'Demo-Bereich 04',
        '8400',
        'Winterthur',
        'pending'
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        '[Demo] Aussichtsbank Winterthur 01',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (8.7281, 47.49293), 4326)::geography,
        'Demo-Bereich 05',
        '8400',
        'Winterthur',
        'approved'
    ),
    (
        'a9a9e81a-668f-5dc5-bb77-4643668a4e93',
        '[Demo] Uferpause Winterthur 01',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (8.7322, 47.49306), 4326)::geography,
        'Demo-Bereich 06',
        '8400',
        'Winterthur',
        'approved'
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        '[Demo] Lesegarten Winterthur 01',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (8.7363, 47.4928), 4326)::geography,
        'Demo-Bereich 07',
        '8400',
        'Winterthur',
        'approved'
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        '[Demo] Öffentlicher Arbeitsbereich Winterthur 01',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (8.7404, 47.49293), 4326)::geography,
        'Demo-Bereich 08',
        '8400',
        'Winterthur',
        'approved'
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        '[Demo] Leseraum Zürich 01',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (8.5294, 47.3707), 4326)::geography,
        'Demo-Bereich 01',
        '8000',
        'Zürich',
        'approved'
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        '[Demo] Parkwiese Zürich 01',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (8.5335, 47.37083), 4326)::geography,
        'Demo-Bereich 02',
        '8000',
        'Zürich',
        'approved'
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        '[Demo] Quartierplatz Zürich 01',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (8.5376, 47.37096), 4326)::geography,
        'Demo-Bereich 03',
        '8000',
        'Zürich',
        'approved'
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        '[Demo] Überdachter Treffpunkt Zürich 01',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (8.5417, 47.3707), 4326)::geography,
        'Demo-Bereich 04',
        '8000',
        'Zürich',
        'approved'
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        '[Demo] Aussichtsbank Zürich 01',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (8.5458, 47.37083), 4326)::geography,
        'Demo-Bereich 05',
        '8000',
        'Zürich',
        'approved'
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        '[Demo] Uferpause Zürich 01',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (8.5499, 47.37096), 4326)::geography,
        'Demo-Bereich 06',
        '8000',
        'Zürich',
        'approved'
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        '[Demo] Lesegarten Zürich 01',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (8.554, 47.3707), 4326)::geography,
        'Demo-Bereich 07',
        '8000',
        'Zürich',
        'approved'
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        '[Demo] Öffentlicher Arbeitsbereich Zürich 01',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (8.5581, 47.37083), 4326)::geography,
        'Demo-Bereich 08',
        '8000',
        'Zürich',
        'approved'
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        '[Demo] Leseraum Bern 01',
        'Fiktiver Demo-Ort. Ein heller Raum mit Einzeltischen für konzentriertes Lesen und Lernen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'library'
        ),
        ST_SetSRID (ST_MakePoint (7.4351, 46.9418), 4326)::geography,
        'Demo-Bereich 01',
        '3000',
        'Bern',
        'approved'
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        '[Demo] Parkwiese Bern 01',
        'Fiktiver Demo-Ort. Eine offene Wiese mit Sitzmöglichkeiten für eine Pause im Grünen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'park'
        ),
        ST_SetSRID (ST_MakePoint (7.4392, 46.94193), 4326)::geography,
        'Demo-Bereich 02',
        '3000',
        'Bern',
        'approved'
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        '[Demo] Quartierplatz Bern 01',
        'Fiktiver Demo-Ort. Ein offener Treffpunkt zwischen kurzen Wegen durch das Quartier. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'square'
        ),
        ST_SetSRID (ST_MakePoint (7.4433, 46.94206), 4326)::geography,
        'Demo-Bereich 03',
        '3000',
        'Bern',
        'approved'
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        '[Demo] Überdachter Treffpunkt Bern 01',
        'Fiktiver Demo-Ort. Ein geschützter Sitzbereich zum Warten und für kurze Treffen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'shelter'
        ),
        ST_SetSRID (ST_MakePoint (7.4474, 46.9418), 4326)::geography,
        'Demo-Bereich 04',
        '3000',
        'Bern',
        'approved'
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        '[Demo] Aussichtsbank Bern 01',
        'Fiktiver Demo-Ort. Eine ruhige Sitzbank mit weitem Blick über die beispielhafte Umgebung. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'viewpoint'
        ),
        ST_SetSRID (ST_MakePoint (7.4515, 46.94193), 4326)::geography,
        'Demo-Bereich 05',
        '3000',
        'Bern',
        'approved'
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        '[Demo] Uferpause Bern 01',
        'Fiktiver Demo-Ort. Ein Rastplatz an einem beispielhaften Wasserweg. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'riverside'
        ),
        ST_SetSRID (ST_MakePoint (7.4556, 46.94206), 4326)::geography,
        'Demo-Bereich 06',
        '3000',
        'Bern',
        'approved'
    ),
    (
        '0bb6574f-129f-5d1e-bd0f-1e70b93dce5f',
        '[Demo] Lesegarten Bern 01',
        'Fiktiver Demo-Ort. Ein kleiner Gartenbereich für ruhige Pausen und gemeinsames Lesen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'garden'
        ),
        ST_SetSRID (ST_MakePoint (7.4597, 46.9418), 4326)::geography,
        'Demo-Bereich 07',
        '3000',
        'Bern',
        'approved'
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        '[Demo] Öffentlicher Arbeitsbereich Bern 01',
        'Fiktiver Demo-Ort. Ein beispielhafter Innenbereich mit Tischen für Laptop und Notizen. Lage und Ausstattung sind illustrative Testdaten.',
        (
            select
                id
            from
                public.categories
            where
                slug = 'workspace'
        ),
        ST_SetSRID (ST_MakePoint (7.4638, 46.94193), 4326)::geography,
        'Demo-Bereich 08',
        '3000',
        'Bern',
        'pending'
    )
    on conflict do nothing;

-- Place Features
insert into
    public.place_features (place_id, feature_id, boolean_value, rating_value)
values
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        5
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        5
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '0d61dfc9-ed58-5ad8-90ed-be71efc44660',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '0d61dfc9-ed58-5ad8-90ed-be71efc44660',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        5
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '87bab896-a8c9-523c-8c94-5cc98cbedae6',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        5
    ),
    (
        '87bab896-a8c9-523c-8c94-5cc98cbedae6',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'f00c95f0-9212-5166-9598-01074bc9bc99',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'f00c95f0-9212-5166-9598-01074bc9bc99',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        5
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'cc1a2333-15f4-5d04-b8fb-d81ec1e4f739',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'cc1a2333-15f4-5d04-b8fb-d81ec1e4f739',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        5
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        5
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '9c5fd532-4173-5e94-8bb5-83ba863ee64a',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '9c5fd532-4173-5e94-8bb5-83ba863ee64a',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        5
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        'a9a9e81a-668f-5dc5-bb77-4643668a4e93',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        'a9a9e81a-668f-5dc5-bb77-4643668a4e93',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        1
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        3
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        false,
        null
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        false,
        null
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        false,
        null
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        false,
        null
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        false,
        null
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        true,
        null
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        true,
        null
    ),
    (
        '0bb6574f-129f-5d1e-bd0f-1e70b93dce5f',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        4
    ),
    (
        '0bb6574f-129f-5d1e-bd0f-1e70b93dce5f',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'quietness'
        ),
        null,
        2
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'seating'
        ),
        true,
        null
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'wifi'
        ),
        true,
        null
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'power-outlets'
        ),
        true,
        null
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'weather-protection'
        ),
        true,
        null
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'toilets'
        ),
        true,
        null
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'wheelchair-accessible'
        ),
        true,
        null
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'green-space'
        ),
        false,
        null
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.features
            where
                slug = 'view'
        ),
        false,
        null
    )
    on conflict do nothing;

-- Place Purposes
insert into
    public.place_purposes (place_id, purpose_id)
values
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'have-a-coffee'
        )
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '6241c068-4e7d-5392-bd19-3ff08fc9641d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'f6d71e37-9381-5834-8a06-310546e19859',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'a5ec7ed2-36bd-529d-927a-ad8f93df571e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '7c4bda1a-49ec-578e-a631-8ee99218a581',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '3122da07-008e-5449-a1c9-3e7be87c83a1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'b8a00a2b-fd75-53c1-8c77-e54e091e44dc',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '99faf78e-4744-53d9-8b91-76eada94d962',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '80dffcb4-e796-57ec-8b77-2116176521e4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '9e5ed3f6-f955-56fc-a2b1-a3f7c3ab5b6b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '022b309d-e799-5985-9ca7-66ca42519127',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'a893e9ab-e8f6-5d60-984b-64d28bc1c9d5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '5b4b466f-b64b-5198-94da-9cd156cd4b18',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '6b13927d-6bb4-5e32-96da-b802ffe66253',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'c083c3b0-1d56-5da1-a25f-8c4874528074',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'c1037a86-8b56-5bd3-a0d1-293410b74185',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'f47983ba-d0d5-5bd6-9aac-b791625d84a3',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '0d61dfc9-ed58-5ad8-90ed-be71efc44660',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '0d61dfc9-ed58-5ad8-90ed-be71efc44660',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '0d61dfc9-ed58-5ad8-90ed-be71efc44660',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'a4de5538-dc3f-5b5d-982d-e0cdb6666552',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '5c252802-2d2a-5a2b-9497-6d5695d35c51',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'cead9cb3-ca08-5031-b85e-5ffb7083f40c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '1c21393f-346f-5a14-bd84-910cd97bb9b1',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'a8589460-fd9f-5673-af45-7a145f14b835',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'bfabfdba-6f18-5cce-94c6-748282cbf6aa',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'f65c7e74-d43c-5ff3-bd80-463c6434e660',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '69e5b21c-82e3-5361-b910-8f84f3e64463',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'de504ccb-b036-5ef0-ac34-7e608a0ae60e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '3452dd94-32f4-55ba-8ec6-b7258050b2b5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '3ff74a40-f18e-5c0b-881f-c89df7fce868',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'ab6dd93b-e444-5650-bd89-812c0da67f91',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '71e84f3e-77ee-52bf-ae04-d044e458146d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '0cf6803a-0847-519c-b430-e40fab1a1c6d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '51b316e0-1b26-591f-aad8-f7b175119697',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'a2c8ebef-2171-5f67-8bd7-e98eb3dc8cf9',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '87bab896-a8c9-523c-8c94-5cc98cbedae6',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '87bab896-a8c9-523c-8c94-5cc98cbedae6',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '5389e1da-62be-5383-aabe-cfe8ef4c3b2a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'a7dcd5ea-c8df-55d7-870e-0b32ed0255fd',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '65a1937f-6b6e-579b-8790-48760fd95026',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'cd03ff06-1f13-5d99-ac69-bc508eb7f27e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '61cd612f-d1ea-50c4-ba4e-c25329b37031',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '7a5f33ee-5baa-52e9-85d1-35353279d815',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '28371548-aa54-5267-ade9-bf329caaff70',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '832d3c2c-7c6c-5461-85d2-69f916f9be66',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'fe745c75-b291-5c07-980f-8fc7b7cab069',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '139526f9-70f3-5c74-a266-71260771cb80',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '31d12abc-cae3-5152-b87e-6c383f663aaf',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '65a9a9a8-53b3-5969-8c73-300b3a97f865',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '6d3e6f64-2fde-567c-a383-05031e65d686',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '83a66488-3b1a-5c43-b387-aaf0468201c7',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '6b98fe40-818e-511d-bbf6-7a9a09d68815',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '6f288dd0-ed82-53a1-ba86-090a32ab3df2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'f00c95f0-9212-5166-9598-01074bc9bc99',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'f00c95f0-9212-5166-9598-01074bc9bc99',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'f00c95f0-9212-5166-9598-01074bc9bc99',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '22182db7-1ef6-5ed2-83b4-f1d996170462',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '63ce0879-7b5a-50c2-bfb1-3644c23a63c2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '90d4eb31-b3ec-56f1-a464-8afd5f0f1d2f',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'ef6b39a5-221c-5980-bc19-0dcc8c218a68',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '80cb07e6-a217-5ea5-882d-13131d1fc35c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '7bc43bcb-7a52-5a77-9acd-d916c2183ab5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'c961b0c5-4c89-5be4-97a6-64f7d9888413',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '0f8ab0cd-90bc-54f5-a3a8-c88d642cd263',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '7155f579-f414-59c0-8101-ddeb2cbf6b96',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '564a7f01-c662-59f0-9b8b-1629777f7246',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '9eb20e0e-45c0-5bbf-96a1-99b23447992a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '83dc2489-2a6e-51f2-91b0-45ad2b35ff9e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '2ea61d32-5de8-5691-b272-025aadffe87c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '12d6ffb3-6148-5beb-86f6-624a23672fa2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '1a79612a-70f8-54ba-830e-cd09651c2e5c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '59b93489-d7f4-5c5a-b8ed-5b637b6f0d6b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'cc1a2333-15f4-5d04-b8fb-d81ec1e4f739',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'cc1a2333-15f4-5d04-b8fb-d81ec1e4f739',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '313fc394-0fa1-5440-a4d8-9af45da5e8f9',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'd58ae2ba-6c3d-50bf-b42c-379f33d7b65a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '43faf806-65bd-55ac-847b-67dd4a432c27',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'fb6826eb-7069-5fca-9071-044c5f02d712',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '0125c1e3-2ecd-567e-94bc-19fbfefd81e7',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'e865237b-0b3b-5eb5-a6e2-79e70a09b285',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '61202edd-97e2-54f7-b808-ee600340525c',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '7334a863-bb65-5e49-991f-c753386c9f02',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '1ec19f3d-2553-54d8-bb7e-984f0ef62cef',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '39987f65-b233-5d3a-82c5-61369279a713',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '88f7340a-a0c8-5540-b2f2-708bcd2f9929',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'e5341731-c9e8-5eb7-b540-acca5dd0128f',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '4290e010-4cee-5deb-a203-9fb6ece92ba5',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'd79baebf-f313-5f2c-9799-d43c92115f31',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '8ece9f27-058d-52b7-989f-1cf6bf42d068',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '29e3a3e3-696f-5cd2-aefe-a12071161264',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '9c5fd532-4173-5e94-8bb5-83ba863ee64a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '9c5fd532-4173-5e94-8bb5-83ba863ee64a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '9c5fd532-4173-5e94-8bb5-83ba863ee64a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'bbee2dc1-d9f3-534b-9a4f-84268c1d4f2b',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'abaaa3a4-8593-5930-839f-74ca43dbfe21',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'c0a37baa-1356-570e-9ca4-396576e57248',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '50d379e2-9f74-5990-862c-0037de6a149e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '7940dfd0-ca2b-55d9-afe0-930ce3d30586',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '09c8c7ce-a4da-59f1-8dc9-cf7636756f31',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'afc02e2a-7e3a-5445-a25d-9964eeda7bd3',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '87582a2a-4633-5c98-9741-84ad22f1ec00',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'f8c52e5e-8d6c-50ba-a1f2-66993a6b9631',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '16b59802-7189-53b6-9d31-7ebbed6d2f62',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'bb2dbcca-cc80-5674-8df2-0061f5bbcfc0',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        'e0b78514-48d0-5474-85bd-be7d4018c5da',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '615b8380-3b6f-5942-8c70-6f19f10ef193',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '9e4c61e7-fca8-5d62-bf42-c1de4c4a8a9e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '36d7ff12-96bf-549e-95be-b7bbfa51fed2',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'adc4081c-89e7-560b-a98c-d6d458c2648a',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'a9a9e81a-668f-5dc5-bb77-4643668a4e93',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'a9a9e81a-668f-5dc5-bb77-4643668a4e93',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'a9a9e81a-668f-5dc5-bb77-4643668a4e93',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'a9a9e81a-668f-5dc5-bb77-4643668a4e93',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '9281d399-4191-5d37-b279-da6e03d9949e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'b5472838-fd1c-5e7c-b622-1340bb785847',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        'bb58c52f-fc48-5359-885c-5321bfc3c759',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'ee253472-67d6-5e49-8825-c92c1f8b67cd',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '23dfde7a-3bb7-50bd-81dd-e402f89e14c3',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '4b87b5b9-43ac-5d76-b530-f4a2cde9718e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'e720f269-b46e-54e6-b681-23b186403a80',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '6f968f7f-3b24-56da-90bf-f6cecbe0d8d4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'b1fa6f26-8cb3-5f24-b0bb-3686c7878548',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        'e1f32235-e2a8-5929-b730-e60aad81cc9e',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    ),
    (
        '47bde0e6-030d-5d35-ac67-6e8cd4343c41',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '181babed-0c30-504d-9c5c-c234ecc99de4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '8908fa73-032e-52af-9cb2-5c46ac8b97c4',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'wait'
        )
    ),
    (
        '563df79e-92e8-50b1-a9be-4f14d481f3ca',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        'cb95a7d6-9c07-5daf-a9ab-33cf9b6ea7db',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'meet-friends'
        )
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'eat'
        )
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '7bf1fdcb-367d-570b-9dee-5db3c373c686',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'walk'
        )
    ),
    (
        '0bb6574f-129f-5d1e-bd0f-1e70b93dce5f',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '0bb6574f-129f-5d1e-bd0f-1e70b93dce5f',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'relax'
        )
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'study'
        )
    ),
    (
        '4fca1b8b-b8dd-5d18-a210-17902a76a85d',
        (
            select
                id
            from
                public.purposes
            where
                slug = 'work-remotely'
        )
    )
    on conflict do nothing;

commit;