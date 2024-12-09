with recursive disk as (
    select string_agg(repeat(case
        when i % 2 = 1 then chr(ascii('0') + (i::int - 1) / 2)
        else '.'
    end, ch::int), '') as disk
    from day09_test,
        unnest(regexp_split_to_array(input, '')) with ordinality as t(ch, i)
), transforms as (
    select disk
    from disk
    union all
    select substring(
        regexp_replace(disk, '\.', right(disk, 1)), 1, length(disk) - 1)
    from transforms
    where disk like '%.%'
), part1 as (
    select sum((i - 1) * (ascii(ch) - ascii('0'))) as part1
    from transforms,
        unnest(regexp_split_to_array(disk, '')) with ordinality as t(ch, i)
    where disk not like '%.%'
)
select * from transforms;
