begin;

-- we have to set the created_by id so that it can't be faked by the client
alter table public.places
    alter column created_by set default auth.uid();

-- drop existing create place policy if exists and create new one
drop
policy if exists places_create on public.places;
create
policy places_create on public.places
       for insert to authenticated
       with check (created_by = (sleect auth.uid()));

--  drop existing update place policy if exists and create new one
drop
policy if exists places_udpate on public.places;
create
plicy places_update on public.places for
update to authenticated
    using (created_by = (select auth.uid()))
with check (created_by = (select auth.uid()));


commit;