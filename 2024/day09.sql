with recursive disk as (
    select string_agg(repeat(case
            when i % 2 = 1 then chr(ascii('0') + (i::int - 1) / 2)
            else '.'
        end, ch::int), '') as disk,
        max((length(input) - 1) / 2) as max_index
    from day09,
        unnest(regexp_split_to_array(input, '')) with ordinality as t(ch, i)
), file_lens as (
    select (i - 1) / 2 as file, ch::int as file_len
    from day09,
        unnest(regexp_split_to_array(input, '')) with ordinality as t(ch, i)
    where i % 2 = 1
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
), transforms2 as (
    select disk, max_index as cur
    from disk
    union all
    select case when free_pos = 0 then disk
            else overlay(replace(disk, file_char, '.')
                placing repeat(file_char, file_len) from free_pos)
        end,
        cur - 1
    from transforms2 t,
        file_lens,
        lateral (select chr(ascii('0') + cur) as file_char),
        lateral (select position(
            repeat('.', file_len) in split_part(disk, file_char, 1)) as free_pos)
    where file_lens.file = cur
), part2 as (
    select sum((i - 1) * (ascii(ch) - ascii('0'))) as part2
    from transforms2,
        unnest(regexp_split_to_array(disk, '')) with ordinality as t(ch, i)
    where cur = -1 and ch != '.'
)
select * from part1, part2;
