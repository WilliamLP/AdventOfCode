-- Bash runtime: 1m31.803s

-- Setup
-- Make a big regexp of alternating case letters.
create temporary table alternating as
with combos as (
    select chr(64 + i) || chr(96 + i) as str
    from generate_series(1, 26) as i
    union all
    select chr(96 + i) || chr(64 + i) as str
    from generate_series(1,26) as i
)
select string_agg(str, '|') as str
from combos;

-- Recursively reduce a bunch of strings, to get the solution to both parts!
-- This input table includes the original string, and 26 strings which remove all of a single letter
create temporary table input as
    select str, true as is_original
    from day5
union all
    select regexp_replace(str, chr(96 + i), '', 'gi') as str, false as is_original
    from day5
    join generate_series(1,26) as i on (true);

with recursive recurse(str, is_original) as (
    select str, is_original from input
union -- Stop on duplicates!
    select regexp_replace(recurse.str, alternating.str, '', 'g') as str, is_original
    from recurse
    join alternating on (true)
)
select is_original, min(length(str)) as final_length
from recurse
group by 1;
