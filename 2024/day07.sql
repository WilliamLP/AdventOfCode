with recursive parsed as (
    select split_part(input, ': ', 1) as target,
        regexp_split_to_array(split_part(input, ': ', 2), ' ') as seq
    from day07
), steps as (
    select target::bigint, seq[1]::bigint as val, seq[2:]::bigint[] as seq
    from parsed
    union all
    select target, case
            when o = '*' then val * seq[1]
            when o = '+' then val + seq[1]
        end, seq[2:]
    from steps, (select '*' union select '+') as ops(o)
    where seq != '{}'
), part1 as (
    select sum(distinct target) as part1
    from steps
    where seq = '{}' and val = target
), steps2 as (
    select target::bigint, seq[1]::bigint as val, seq[2:]::bigint[] as seq
    from parsed
    union all
    select target, case
            when o = '*' then val * seq[1]
            when o = '+' then val + seq[1]
            when o = '||' then (val::text || seq[1])::bigint
        end, seq[2:]
    from steps2, (select '*' union select '+' union select '||') as ops(o)
    where seq != '{}'
), part2 as (
    select sum(distinct target) as part2
    from steps2
    where seq = '{}' and val = target
)
select * from part1, part2;