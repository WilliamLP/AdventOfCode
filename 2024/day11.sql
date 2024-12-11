with recursive start as (
    select unnest(regexp_split_to_array(input, ' ')) as val
    from day11
), blinks as (
    select 0 as i, val::bigint
    from start
    union all
    select i + 1, case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end
    from blinks,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    where i < 25
)
select count(*) as part1 from blinks where i = 25;
