begin;

alter table public.places
    alter column created_by set default auth.uid();

drop policy if exists places_create on public.places;
drop policy if exists "authenticated users can create pending places" on public.places;

create policy places_create
    on public.places
    for insert
    to authenticated
    with check (
        created_by = (select auth.uid())
        and status = 'pending'
    );

drop policy if exists places_update on public.places;

create policy places_update
    on public.places
    for update
    to authenticated
    using (created_by = (select auth.uid()))
    with check (created_by = (select auth.uid()));

commit;
