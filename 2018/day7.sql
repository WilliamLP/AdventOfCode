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

-- Part 1
with recursive next_step(todo, unmet, done) as (
    select
        (
            select string_agg(step, '' order by step)
            from steps),
        (   select string_agg(distinct step, '' order by step)
            from parsed),
        ''
union
    select
        -- Take next step out of todo
        replace(
            todo,
            (
                select min(chr) from (select regexp_split_to_table(todo, '') as chr) as chrs
                where position(chr in unmet) = 0),
            ''),
        -- Recalculate dependencies
        (
            select coalesce(string_agg(distinct step, '' order by step), '')
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
-- select * from next_step
select done
from next_step
where todo = '';

-- Part 2

create temporary table config as
select 5 as num_workers,
    60 as time_offset;

-- Divide turn into phases:
--   Get Next - pick next available job
--   Dispatch - Give job in queue to a free worker
--   Tick - Advance time
--   Update - Update dependencies
-- Data structure:
--   phase: current phase
--   todo: Jobs remaining
--   blocked: Jobs with unmet dependencies
--   done: Jobs done
--   next: Next job to do
--   worker_jobs: Currently assigned jobs per worker (as string)
--   worker_time: Currently assigned job time
with recursive next_step(phase, todo, blocked, done, next, worker_jobs, worker_time) as (
    select
        'Get Next',
        (
            select string_agg(step, '' order by step)
            from steps),
        (   select string_agg(distinct step, '' order by step)
            from parsed),
        '',
        '',
        (
            select string_agg('.', '')
            from config
            join generate_series(1, config.num_workers) as seq on (true)
        ),
        (
            select array_agg(0)
            from config
            join generate_series(1, config.num_workers) as seq on (true)
        )
union all
    select
        -- phase: Advance to next phase
        case when phase = 'Get Next' then 'Dispatch'  -- Pluck a job if possible => dispatch
            when phase = 'Dispatch' and (next = '' or position('.' in worker_jobs) = 0) then 'Tick' -- No job to dispatch => wait
            when phase = 'Dispatch' then 'Get Next' -- Assign queued job to a worker => Try to queue another
            when phase = 'Tick' then 'Update' -- Advance clock => Update
            when phase = 'Update' then 'Get Next' -- Refresh dependencies => Try to start another job
            end,
        -- todo: Move next here during Dispatch, if a worker is free
        case when phase = 'Dispatch' and next != '' and position('.' in worker_jobs) != 0 then replace(todo, next, '')
            else todo end,
        -- blocked: Recalculate this during Update phase
        case when phase = 'Update' then
                (select coalesce(string_agg(distinct step, '' order by step), '')
                from parsed
                where position(depends_on_step in done) = 0)
            else blocked end,
        -- done: Add finishing jobs here during Tick phase
        case when phase = 'Tick' then
                done || (select string_agg(case when worker_time[i] - 1 = 0 then
                    substring(worker_jobs, i, 1) else '' end, '')
                    from generate_series(1, length(worker_jobs)) as i)
            else done end,
        -- next: Pluck a job from here during Get Next phase
        case when phase = 'Get Next' and position('.' in worker_jobs) != 0 then coalesce(
            (select min(chr) from (select regexp_split_to_table(todo, '') as chr) as chrs
                where position(chr in blocked) = 0), '')
            when phase = 'Dispatch' and next != '' then ''
            else next end,
        -- worker_jobs: Move next to a free worker during Dispatch. Mark worker free during Update
        case when phase = 'Dispatch' and next != '' and position('.' in worker_jobs) != 0 then
                regexp_replace(worker_jobs, '\.', next)
            when phase = 'Update' then
                (select string_agg(case when worker_time[i] = 0 then '.' else substring(worker_jobs, i, 1) end, '')
                    from generate_series(1, length(worker_jobs)) as i)
            else worker_jobs end,
        -- worker_time: Count down clocks during Tick, set initial job time during Dispatch
        case when phase = 'Tick' then
                (select array_agg(greatest(0, worker_time[i] - 1))
                    from generate_series(1, length(worker_jobs)) as i)
            when phase = 'Dispatch' and next != '' then
                (select array_agg(case when i = position('.' in worker_jobs) then ascii(next) - 64 + config.time_offset
                    else worker_time[i] end)
                    from generate_series(1, length(worker_jobs)) as i
                    join config on (true))
            else worker_time end
    from next_step
    where length(done) < (select count(*) from steps)  -- Terminate when we've done all steps
)
--select * from next_step;
select count(*) from next_step where phase = 'Tick';
