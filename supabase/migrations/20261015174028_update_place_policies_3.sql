begin;

drop
policy if exists places_create on public.places;

create
policy places_create
    on public.places
           for insert
           to authenticated
           with check(
               created_by = (select auth.uid())
           );

commit;
