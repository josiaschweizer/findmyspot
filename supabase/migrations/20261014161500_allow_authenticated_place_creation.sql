grant usage on schema public to authenticated;

grant select, insert on table public.places to authenticated;
grant select on table public.categories to authenticated;
grant select on table public.features to authenticated;
grant select, insert on table public.place_features to authenticated;

alter table public.places enable row level security;
alter table public.place_features enable row level security;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'places'
      and policyname = 'users can view their own places'
  ) then
    create policy "users can view their own places"
      on public.places
      for select
      to authenticated
      using ((select auth.uid()) = created_by);
  end if;
end
$$;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'places'
      and policyname = 'authenticated users can create pending places'
  ) then
    create policy "authenticated users can create pending places"
      on public.places
      for insert
      to authenticated
      with check (
        (select auth.uid()) = created_by
        and status = 'pending'
      );
  end if;
end
$$;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'place_features'
      and policyname = 'users can add features to their own places'
  ) then
    create policy "users can add features to their own places"
      on public.place_features
      for insert
      to authenticated
      with check (
        exists (
          select 1
          from public.places
          where places.id = place_features.place_id
            and places.created_by = (select auth.uid())
        )
      );
  end if;
end
$$;
