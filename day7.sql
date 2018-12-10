-- Bash runtime:

-- Setup
create temporary table parsed as
with match as (
    select regexp_match(str, '^Step (\w+) must be finished before step (\w+)') as match
    from day7
)
select match[1] as depends_on_step, match[2] as step
from match;

create temporary table steps as
select distinct step
from parsed
union
select distinct depends_on_step
from parsed;

with recursive next_step(todo, unmet, done) as (
    select
        (select string_agg(step, '' order by step)
            from steps),
        (select string_agg(distinct step, '' order by step)
            from parsed),
        ''
union
    select
        -- Take next step out of todo
        replace(
            todo,
            (select min(chr) from (select regexp_split_to_table(todo, '') as chr) as chrs
                where position(chr in unmet) = 0),
            ''),
        -- Recalculate dependencies
        (select coalesce(string_agg(distinct step, '' order by step), '')
                -- coalesce prevents this going null and terminating the recursion
            from parsed
            where position(depends_on_step in done) = 0 -- Met if we've done the step before
                and depends_on_step != (  -- Also met if fulfilled by the next step
                    select min(chr) from (select regexp_split_to_table(todo, '') as chr) as chrs
                    where position(chr in unmet) = 0)
        ),
        -- Append next step to done
        done || (select min(chr) from (select regexp_split_to_table(todo, '') as chr) as chrs
            where position(chr in unmet) = 0)
    from next_step
)
select * from next_step;
