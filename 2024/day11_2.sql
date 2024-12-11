with p00 as (
    select unnest(regexp_split_to_array(input, ' '))::bigint as val, count(*) as multiplicity
    from day11
    group by 1
), p01 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p00,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p02 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p01,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p03 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p02,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p04 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p03,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p05 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p04,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p06 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p05,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p07 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p06,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p08 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p07,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p09 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p08,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p10 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p09,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p11 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p10,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p12 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p11,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p13 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p12,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p14 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p13,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p15 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p14,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p16 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p15,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p17 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p16,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p18 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p17,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p19 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p18,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p20 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p19,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p21 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p20,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p22 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p21,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p23 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p22,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p24 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p23,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p25 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p24,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p26 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p25,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p27 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p26,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p28 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p27,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p29 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p28,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p30 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p29,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p31 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p30,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p32 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p31,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p33 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p32,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p34 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p33,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p35 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p34,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p36 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p35,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p37 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p36,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p38 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p37,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p39 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p38,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p40 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p39,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p41 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p40,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p42 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p41,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p43 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p42,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p44 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p43,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p45 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p44,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p46 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p45,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p47 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p46,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p48 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p47,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p49 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p48,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p50 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p49,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p51 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p50,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p52 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p51,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p53 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p52,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p54 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p53,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p55 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p54,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p56 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p55,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p57 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p56,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p58 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p57,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p59 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p58,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p60 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p59,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p61 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p60,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p62 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p61,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p63 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p62,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p64 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p63,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p65 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p64,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p66 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p65,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p67 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p66,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p68 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p67,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p69 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p68,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p70 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p69,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p71 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p70,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p72 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p71,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p73 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p72,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p74 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p73,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
), p75 as (
    select case
        when j = 2 then substring(val::text, length(val::text) / 2 + 1)::bigint
        when val = 0 then 1
        when not is_even_len then val * 2024
        else substring(val::text, 1, length(val::text) / 2)::bigint
    end as val, sum(multiplicity) as multiplicity
    from p74,
    lateral (select length(val::text) % 2 = 0 as is_even_len),
    lateral (select generate_series(1, 1 + is_even_len::int) as j)
    group by 1
)
select sum(multiplicity) from p75 as part2;
