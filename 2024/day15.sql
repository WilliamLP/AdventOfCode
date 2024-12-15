with recursive divider as (
    select row_num as div from day15 where input = ''
), map_cells as (
    select row_num as i, j, ch
    from day15, divider,
        unnest(regexp_split_to_array(input, '')) with ordinality as r(ch, j)
    where row_num < div
), moves as (
    select row_number() over(order by row_num, j)::int as t,
        case when ch = '<' then -1 when ch = '>' then 1 else 0 end as dj,
        case when ch = '^' then -1 when ch = 'v' then 1 else 0 end as di
    from day15, divider,
        unnest(regexp_split_to_array(input, '')) with ordinality as r(ch, j)
    where row_num > div
), start_map as (
    select array_agg(
        (select array_agg(case when ch = '@' then '.' else ch end order by j)
         from map_cells c2 where c2.i = c1.i) order by i
    ) as map
    from (select distinct i from map_cells) c1
), bounds as (
    select max(array_length(map, 1)) as height, max(array_length(map, 2)) as width
    from start_map
), states as (
    select 1 as t,
        (select i from map_cells where ch = '@') as i,
        (select j from map_cells where ch = '@') as j,
        map, '' as _path, 0 as _di, 0 as _dj, 0 as _k
    from start_map
    union all
    select t + 1,
        case when free_k is not null then i + di else i end,
        case when free_k is not null then j + dj else j end,
        case when free_k is null or next_ch = '.' then map else (
            select array_agg(
                (select array_agg(
                    case when mi = i + di and mj = j + dj then '.'
                        when mi = i + free_k * di and mj = j + free_k * dj then 'O'
                        else map[mi][mj]
                    end
                order by mj)
                from generate_series(1, width) as mj
            order by mi))
            from bounds, generate_series(1, height) as mi
        ) end,
        path, di, dj, free_k
    from states
    join moves using(t)
    cross join bounds
    cross join lateral (
        select map[i + di][j + dj] as next_ch
    ) as next_ch
    cross join lateral (
        select string_agg(map[i + di * k][j + dj * k], '' order by k) as path
        from generate_series(1, array_length(map, 1)) as s(k)
        where (i + di * k) between 1 and width and (j + dj * k) between 1 and height
    ) as lookahead
    cross join lateral (
        select case when position('.' in path) = 0
                or position('.' in path) > position('#' in path) then null
            else position('.' in path) end as free_k
    ) as free_space
), last_state as (
    select map from states order by t desc limit 1
), part1 as (
    select sum(100 * ((ij - 1) / width) + ((ij - 1) % width)) as part1
    from last_state, bounds, unnest(map) with ordinality as u(ch, ij)
    where ch = 'O'
)
select * from part1;
--select map[i + 0 : i + 0][1:width] from last_state, bounds, generate_series(1, height) as i;