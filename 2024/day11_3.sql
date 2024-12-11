with recursive start as (
    select array_agg((val::bigint, 1::bigint)) as vals
    from day11, unnest(regexp_split_to_array(input, ' ')) as t(val)
), blinks as (
    select 0 as i, vals from start
    union all
    select i + 1, (
        select array_agg((val, m::bigint))
        from (
            select case
                when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
                when val = 0 then 1
                when not is_even_len then val * 2024
                else substring(val::text, 1, length(val::text) / 2)::bigint
            end as val, sum(m) as m
            from unnest(vals) as t(val bigint, m bigint),
            lateral (select length(val::text) % 2 = 0 as is_even_len),
            lateral (select generate_series(1, 1 + is_even_len::int) as j)
            group by 1
        )
    )
    from blinks where i < 75
)
select i, sum(m)
from blinks, unnest(vals) as t(v bigint, m bigint)
where i in (25, 75)
group by 1 order by 1;
