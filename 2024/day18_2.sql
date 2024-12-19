create temporary table bytes as
select row_num t, split_part(input, ',', 1)::int x, split_part(input, ',', 2)::int y
from day18;

create temporary table grid as
select x::int, y::int, coalesce(t, 9999) t
from generate_series(0, 70) x cross join generate_series(0, 70) y left join bytes b using(x, y);
create index i on grid(x, y);

with recursive visited as (
    select t, 0 x, 0 y from bytes
    union
    select v.t, g.x, g.y from visited v, grid g
    where ((v.x = g.x and v.y = g.y - 1) or (v.x = g.x and v.y = g.y + 1)
        or (v.x = g.x - 1 and v.y = g.y) or (v.x = g.x + 1 and v.y = g.y)) and v.t < g.t
)
select x || ',' || y from bytes where t = (
    select max(t) + 1 from visited where x = 70 and y = 70);

