with recursive bounds as (
    select max(length(input)) as width, count(*) as height
    from day12
), plants as (
    select ch, row_num - 1 as i, j - 1 as j, (row_num - 1) * width + j - 1 as id
    from day12,
        unnest(regexp_split_to_array(input, '')) with ordinality as t(ch, j),
        bounds
), adjs as (
    select p1.id as id1, p2.id as id2, p2.i - p1.i as di, p2.j - p1.j as dj
    from plants p1, plants p2
    where p1.ch = p2.ch and abs(p1.i - p2.i) + abs(p1.j - p2.j) = 1
), flood as (
    -- upper left corners of a region, needs deduplication later
    select id as start, ch, array[id] as plants
    from plants p
    left join adjs a_left on (a_left.id1 = p.id and a_left.dj = -1)
    left join adjs a_up on (a_up.id1 = p.id and a_up.di = -1)
    where a_left is null and a_up is null
    union -- "union all" would yield infinite loop
    select start, ch, (
        select array_agg(distinct id order by id)
        from (
            select id
            from unnest(plants) as id
            union
            select adjs.id2
            from unnest(plants) as id
            join adjs on (adjs.id1 = id)
        ) t
    )
    from flood
), largest as (
    select distinct on (start)
        start, ch, plants
    from flood
    order by start, array_length(plants, 1) desc
), regions as (
    -- deduplicate
    select plants, min(ch) as ch, min(start) as start
    from largest
    group by 1
), plant_perims as (
    select id,
        a_up is null as p_up,
        a_down is null as p_down,
        a_left is null as p_left,
        a_right is null as p_right
    from plants
    left join adjs a_up on (a_up.id1 = id and a_up.di = -1)
    left join adjs a_down on (a_down.id1 = id and a_down.di = 1)
    left join adjs a_left on (a_left.id1 = id and a_left.dj = -1)
    left join adjs a_right on (a_right.id1 = id and a_right.dj = 1)
), plant_perims2 as (
    select pp.id,
        pp.p_up and not coalesce(pp_left.p_up, false) as p2_up,
        pp.p_down and not coalesce(pp_left.p_down, false) as p2_down,
        pp.p_left and not coalesce(pp_up.p_left, false) as p2_left,
        pp.p_right and not coalesce(pp_up.p_right, false) as p2_right
    from plant_perims pp
    left join adjs a_up on (a_up.id1 = pp.id and a_up.di = -1)
    left join adjs a_down on (a_down.id1 = pp.id and a_down.di = 1)
    left join adjs a_left on (a_left.id1 = pp.id and a_left.dj = -1)
    left join adjs a_right on (a_right.id1 = pp.id and a_right.dj = 1)
    left join plant_perims pp_up on (pp_up.id = a_up.id2)
    left join plant_perims pp_down on (pp_down.id = a_down.id2)
    left join plant_perims pp_left on (pp_left.id = a_left.id2)
    left join plant_perims pp_right on (pp_left.id = a_right.id2)
), region_perims as (
    select start, min(ch),
        sum(p_up::int + p_down::int + p_left::int + p_right::int) as p1,
        sum(p2_up::int + p2_down::int + p2_left::int + p2_right::int) as p2
    from regions
    cross join unnest(plants) as id
    join plant_perims using(id)
    join plant_perims2 using(id)
    group by 1
)
select sum(p1 * array_length(plants, 1)) as part1,
    sum(p2 * array_length(plants, 1)) as part2
from regions
join region_perims using(start);
