with recursive map as (
    select array_agg(replace(input, '^', '.')) as map,
        max(length(input)) as max_j,
        max(row_num) as max_i,
        max(case when input like '%^%' then row_num end) as start_i,
        max(position('^' in input)) as start_j
    from day06
), obstacles as (
    select oi, oj
    from map
    cross join generate_series(1, max_i) as oi
    cross join generate_series(1, max_j) as oj
    where oi != start_i or oj != start_j
    union all
    select -1, -1
), steps as (
    select 0 as t, oi, oj, start_i as i, start_j as j, -1 as di, 0 as dj
    from map, obstacles
    union all
    select t + 1, oi, oj,
        case when next_tile = '.' then next_i else i end,
        case when next_tile = '.' then next_j else j end,
        case when next_tile = '.' then di else dj end,
        case when next_tile = '.' then dj else -di end
    from steps, map, lateral (
        select i + di as next_i, j + dj as next_j, case
            when not (i + di between 1 and max_i)
                or not (j + dj between 1 and max_j)  then null
            when i + di = oi and j + dj = oj then 'O'
            else substring(map.map[i + di], j + dj, 1)
        end as next_tile
    ) as new_pos
    where t < max_i * max_j and new_pos.next_tile is not null
), part1 as (
    select count(distinct (i,j))
    from steps
    where (oi, oj) = (-1, -1)
), part2 as (
    select count(distinct (oi, oj))
    from steps, map
    where t = max_i * max_j
)
select * from part1, part2;