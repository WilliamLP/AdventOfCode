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

create temporary table test as (select 'dabAcCaCBAcCcaDA' as str);

-- Part 1
-- Recursively reduce the string!
with recursive recurse(str) as (
    select str
    from day5
union -- Stop on duplicate!
    select regexp_replace(recurse.str, alternating.str, '', 'g') as str
    from recurse
    join alternating on (true)
)
select min(length(str))
from recurse;


-- Part 2: do this by removing each letter of the alphabet!
create temporary table removed as
select regexp_replace(str, chr(96 + i), '', 'gi') as str
from day5
join generate_series(1,26) as i on (true);

with recursive recurse(str) as (
    select str
    from removed
union -- Stop on duplicate!
    select regexp_replace(recurse.str, alternating.str, '', 'g') as str
    from recurse
    join alternating on (true)
)
select min(length(str)) from recurse;