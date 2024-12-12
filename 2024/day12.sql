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
    select plants, min(start) as start
    from largest
    group by 1
), adj_counts as (
    select id, count(*) as adj_count
    from plants
    join adjs on (id1 = id)
    group by 1
), region_perims as (
    select start, sum(4 - coalesce(adj_count, 0)) as perim
    from regions
    cross join unnest(plants) as id
    left join adj_counts using(id)
    group by 1
), part1 as (
    select sum(array_length(plants, 1) * perim) as part1
    from regions
    join region_perims using(start)
)
select * from part1;