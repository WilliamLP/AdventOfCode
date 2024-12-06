
with split as (
    select split_part(input, '   ', 1)::int as id1,
           split_part(input, '   ', 2)::int as id2
    from day01
), t1 as (
    select id1, row_number() over(order by id1) as rn
    from split order by 1
), t2 as (
    select id2, row_number() over(order by id2) as rn
    from split order by 1
), t2_counts as (
    select id2, count(*) as count
    from t2 group by 1
), part1 as (
    select sum(abs(id1 - id2)) as part1
    from t1 join t2 using (rn)
), part2 as (
    select sum(id1 * count) as part2
    from t1 join t2_counts on (t2_counts.id2 = id1)
)
select part1, part2 from part1, part2;
