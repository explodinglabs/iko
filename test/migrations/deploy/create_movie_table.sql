create table movie (
  id bigint generated always as identity primary key,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null
);
