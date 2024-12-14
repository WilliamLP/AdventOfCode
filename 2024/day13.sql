with grps as (
    select floor(row_num / 4) as id, trim(string_agg(input, ' ')) as input from day13 group by 1
), matches as (
    select id, regexp_matches(input,
        'Button A: X\+(\d+), Y\+(\d+) Button B: X\+(\d+), Y\+(\d+) Prize: X=(\d+), Y=(\d+)'
        ) as m
    from grps
), configs as (
    select id, m[1]::bigint x1, m[2]::bigint y1, m[3]::bigint x2, m[4]::bigint y2,
        m[5]::bigint xprize, m[6]::bigint yprize,
        m[5]::bigint + 10000000000000 as xprize2, m[6]::bigint + 10000000000000 as yprize2
    from matches
), solves as (
    select id, a, b
    from configs,
    lateral (select (x1 * yprize - y1 * xprize) / (x1 * y2 - x2 * y1) as b),
    lateral (select (xprize - b * x2) / x1 as a)
    where a*x1 + b*x2 = xprize and a*y1 + b*y2 = yprize
), solves2 as (
    select id, a, b
    from configs,
    lateral (select (x1 * yprize2 - y1 * xprize2) / (x1 * y2 - x2 * y1) as b),
    lateral (select (xprize2 - b * x2) / x1 as a)
    where a*x1 + b*x2 = xprize2 and a*y1 + b*y2 = yprize2
), part1 as (
    select sum(a * 3 + b) as part1
    from solves
    where a <= 100 and b <= 100
), part2 as (
    select sum(a * 3 + b) as part2
    from solves2
)
select * from part1, part2;