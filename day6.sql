-- Bash runtime:

-- Setup
create temporary table parsed as
with match as (
    select id, regexp_match(str, '(\d+), (\d+)') as match
    from day6
)
select id, match[1]::int as x, match[2]::int as y
from match;

create temporary table extent as
select min(x) as minx, min(y) as miny, max(x) as maxx, max(y) as maxy
from parsed;

-- Table with a row for each grid square
create temporary table grid as
select x, y
from extent
join generate_series(minx, maxx) as x on (true)
join generate_series(miny, maxy) as y on (true);

-- Part 1
with dists as (
    -- distance from every grid square to each coordinate
    select grid.x, grid.y, parsed.id,
        abs(parsed.x - grid.x) + abs(parsed.y - grid.y) as dist
    from grid
    join parsed on (true)
), min_dist as (
    -- Distance to the closest coordinate, per grid square
    select x, y, min(dist) as dist
    from dists
    group by 1, 2
), closest_coords as (
    select md.x, md.y, min(d.id) as id, min(md.dist) as dist
    from dists d
    join min_dist md on (md.x = d.x and md.y = d.y and md.dist = d.dist)
    group by 1,2
    having count(*) = 1  -- Min dist must be unique to a single coordinate
), on_border as (
    select distinct id
    from closest_coords
    join extent on (true)
    where x in (minx, maxx) or y in (miny, maxy)
), areas as (
    select id, count(*) as area
    from closest_coords
    group by 1
)
-- Show the grid for debugging
--select string_agg(
--    case when c.id is null then ' '
--        when c.dist = 0 then chr(64+id)
--        else chr(96+id) end, '')
--from grid g left join closest_coords c on (g.x = c.x and g.y = c.y) group by g.y order by g.y;
select max(area)
from areas
where id not in (select id from on_border);