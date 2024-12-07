with cells as (
    select row_num as i, j, ch
    from day04,
        unnest(regexp_split_to_array(input, '')) with ordinality as chars(ch, j)
), dirs as (
    select di, dj
    from generate_series(-1, 1) as di,
        generate_series(-1, 1) as dj
    where (di, dj) != (0, 0)
), part1 as (
    select count(*) as part1
    from cells c1
    cross join dirs
    join cells c2 on (c1.i + 1 * di = c2.i and c1.j + 1 * dj = c2.j)
    join cells c3 on (c1.i + 2 * di = c3.i and c1.j + 2 * dj = c3.j)
    join cells c4 on (c1.i + 3 * di = c4.i and c1.j + 3 * dj = c4.j)
    where c1.ch || c2.ch || c3.ch || c4.ch = 'XMAS'
), part2 as (
    select count(*) as part2
    from cells c
    join cells ul on (ul.i + 1 = c.i and ul.j + 1 = c.j)
    join cells ur on (ur.i + 1 = c.i and ur.j - 1 = c.j)
    join cells ll on (ll.i - 1 = c.i and ll.j + 1 = c.j)
    join cells lr on (lr.i - 1 = c.i and lr.j - 1 = c.j)
    where c.ch = 'A'
        and ul.ch || lr.ch in ('MS', 'SM')
        and ur.ch || ll.ch in ('MS', 'SM')
)
select * from part1, part2;
