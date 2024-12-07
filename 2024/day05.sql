with recursive separator as (
    select row_num from day05 where input = ''
), rules as (
    select split_part(input, '|', 1) as n1, split_part(input, '|', 2) as n2
    from day05, separator s
    where day05.row_num < s.row_num
), seqs as (
    select day05.row_num as id, regexp_split_to_array(input, ',') as seq
    from day05, separator s
    where day05.row_num > s.row_num
), missed as (
    select distinct s.id, s.seq
    from seqs s
    cross join rules r
    where array_position(s.seq, r.n1) > array_position(s.seq, r.n2)
), part1 as (
    select sum(seq[(array_length(seq, 1) + 1) / 2]::int) as part1
    from seqs
    where id not in (select id from missed)
), top_sort as (
    select 0 as i, id, seq, array[]::text[] as sorted
    from missed
    union all
    select i + 1 as i, id, seq, sorted || new.new
    from top_sort,
    lateral (
        select array_agg(distinct n) as new
        from unnest(seq) as seq(n)
        where not n = any(sorted) and n not in (
            select n2 from rules
            where n1 = any(seq) and not n1 = any(sorted)
        )
    ) as new
    where new.new != '{}'
), sorted_missed as (
    select distinct on (id) sorted as seq
    from top_sort
    order by id, i desc
), part2 as (
    select sum(seq[(array_length(seq, 1) + 1) / 2]::int) as part2
    from sorted_missed
)
select * from part1, part2;
