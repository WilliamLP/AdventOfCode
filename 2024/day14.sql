with dims as (
    select 101 as width, 103 as height, 100 as time, 10000 as max_t
), parsed as (
    select regexp_matches(input, 'p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)') bot
    from day14
), bots as (
    select bot[1]::int as x, bot[2]::int as y,
        (bot[3]::int + width) % width as vx, (bot[4]::int + height) % height as vy
    from parsed, dims
), moved as (
    select t, (x + vx * t) % width as x, (y + vy * t) % height as y
    from bots, dims, generate_series(1, max_t) as t
), quads as (
    select x / (width / 2 + 1) as qx, y / (height / 2 + 1) as qy, count(*) as count
    from moved, dims
    where t = time and x != (width / 2) and y != (height / 2)
    group by 1, 2
), part1 as (
    select exp(sum(ln(count)))::int as part1 from quads
), moved_aggr as (
    select t, x, y, count(*) as count from moved group by 1, 2, 3
), part2 as (  -- Generate picture for inspection
    select t.t, string_agg(coalesce(m.count::text, '.'), '' order by x.x) as row
    from dims
    cross join generate_series(1, max_t) t(t)
    cross join generate_series(0, width - 1) x(x)
    cross join generate_series(0, height - 1) y(y)
    left join moved_aggr m on (m.t = t.t and m.x = x.x and m.y = y.y)
    group by t.t, y.y order by t.t, y.y
)
select null::int, 'Part 1 answer:' || part1 from part1
union all select * from part2
where t in (select distinct t from part2 where row ~ '[^.]{8,}');