with bounds as (
    select max(length(input)) as max_j, count(*) as max_i
    from day08
), antennas as (
    select ch, row_num as i, j
    from day08,
        unnest(regexp_split_to_array(input, '')) with ordinality as r(ch, j)
    where ch != '.'
), antinodes as (
    select a1.ch, a1.i + (a1.i - a2.i) as i, a1.j + (a1.j - a2.j) as j
    from antennas a1
    join antennas a2 on (a2.ch = a1.ch and (a1.i, a1.j) != (a2.i, a2.j))
), part1 as (
    select count(distinct (i, j)) as part1
    from antinodes, bounds
    where (i between 1 and max_i) and (j between 1 and max_j)
), antinodes2 as (
    select a1.ch, ci as i, cj as j
    from antennas a1
    join antennas a2 on (a2.ch = a1.ch and (a1.i, a1.j) != (a2.i, a2.j))
    cross join bounds
    cross join generate_series(1, max_i) as ci
    cross join generate_series(1, max_j) as cj
    where (a1.j - cj) * (a2.i - ci) - (a2.j - cj) * (a1.i - ci) = 0
), part2 as (
    select count(distinct (i, j)) as part2
    from antinodes2
)
select * from part1, part2;