with split as (
    select regexp_split_to_table(string_agg(input, ''), 'do\(\)') as input
    from day03
), two_parts as (
    select 1 as part, input
    from split
    union all
    select 2, regexp_replace(input, 'don\''t\(\).*$', '')
    from split
), parsed as (
    select part, regexp_matches(input, 'mul\((\d+)\,(\d+)\)', 'g') as nums
    from two_parts
)
select part, sum(nums[1]::int * nums[2]::int) as answer
from parsed
group by 1 order by 1;