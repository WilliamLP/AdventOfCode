with recursive sites as (
    select (row_num, j) as id, row_num as i, j, ch::int as val
    from day10,
        unnest(regexp_split_to_array(input, '')) with ordinality as t(ch, j)
), edges as (
    select s1.id as s1_id, s2.id as s2_id
    from sites s1, sites s2
    where s2.val = s1.val + 1
        and abs(s1.i - s2.i) + abs(s1.j - s2.j) = 1
), steps as (
    select id src, id as cur_site, 0 as cur_level
    from sites
    where val = 0
    union all
    select src, edges.s2_id, cur_level + 1
    from steps
    join edges on (edges.s1_id = steps.cur_site)
)
select count(distinct (src, cur_site)) as part1,
    count(*) as part2
from steps
where cur_level = 9;
