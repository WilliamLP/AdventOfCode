
with parsed as (
    select row_num, n::int as n, i
    from day02,
        unnest(regexp_split_to_array(input, ' ')) with ordinality as arr(n, i)
), row_stats as (
    select t1.row_num, MAX(t2.n - t1.n) as max_diff, MIN(t2.n - t1.n) as min_diff
    from parsed t1 join parsed t2 on (t1.row_num = t2.row_num and t2.i = t1.i + 1)
    group by 1
), part1 as (
    select count(*) as part1
    from row_stats
    where min_diff >= 1 and max_diff <= 3
        or min_diff >= -3 and max_diff <= -1
), subseqs as (
    select p1.row_num, p2.i as excluded, p1.n,
        row_number() over (partition by p1.row_num, p2.i order by p1.i) as i
    from parsed p1
    join parsed p2 using (row_num)
    where p1.i != p2.i
), subseq_stats as (
    select t1.row_num, t1.excluded, MAX(t2.n - t1.n) as max_diff, MIN(t2.n - t1.n) as min_diff
    from subseqs t1 join subseqs t2 on (
        t1.row_num = t2.row_num and t1.excluded = t2.excluded and t2.i = t1.i + 1)
    group by 1, 2
), part2 as (
    select count(distinct row_num) as part2
    from subseq_stats
    where min_diff >= 1 and max_diff <= 3
        or min_diff >= -3 and max_diff <= -1
)
select * from part1, part2;