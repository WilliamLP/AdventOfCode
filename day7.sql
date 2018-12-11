-- Bash runtime:

-- Setup
create temporary table parsed as
with match as (
    select regexp_match(str, '^Step (\w+) must be finished before step (\w+)') as match
    from day7_test
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
select 2 as num_workers;

-- Divide turn into phases:
--   Queue - pick next available job
--   Dispatch - Give job in queue to a free worker
--   Tick - Advance time
--   Update - Update dependencies
-- Data structure:
--   phase: current phase
--   todo: Jobs remaining
--   unmet: Jobs with unmet dependencies
--   done: Jobs done
--   queue: Next job to do
--   worker_jobs: Currently assigned jobs per worker (as string)
--   worker_time: Currently assigned job time
with recursive next_step(phase, todo, unmet, done, queue, worker_jobs, worker_time) as (
    select
        'Queue',
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
        case when phase = 'Queue' then 'Dispatch'  -- Pluck a job if possible => dispatch
            when phase = 'Dispatch' and (queue = '' or position('.' in worker_jobs) = 0) then 'Tick' -- No job to dispatch => wait
            when phase = 'Dispatch' then 'Queue' -- Assign queued job to a worker => Try to queue another
            when phase = 'Tick' then 'Update' -- Advance clock => Update
            when phase = 'Update' then 'Queue' -- Refresh dependencies => Try to queue
            end,
        -- todo: Move queue here during Dispatch, if a worker is free
        case when phase = 'Dispatch' and queue != '' and position('.' in worker_jobs) != 0 then replace(todo, queue, '')
            else todo end,
        -- unmet: Recalculate this during Update phase
        case when phase = 'Update' then
                (select coalesce(string_agg(distinct step, '' order by step), '')
                from parsed
                where position(depends_on_step in done) = 0)
            else unmet end,
        -- done: Add finishing jobs here during Tick phase
        case when phase = 'Tick' then
                done || (select string_agg(case when worker_time[i] - 1 = 0 then
                    substring(worker_jobs, i, 1) else '' end, '')
                    from generate_series(1, length(worker_jobs)) as i)
            else done end,
        -- queue: Pluck a job from here during Queue phase
        case when phase = 'Queue' then coalesce(
            (select min(chr) from (select regexp_split_to_table(todo, '') as chr) as chrs
                where position(chr in unmet) = 0), '')
            when phase = 'Dispatch' and queue != '' and position('.' in worker_jobs) != 0 then ''
            else queue end,
        -- worker_jobs: Move queue to a free worker during Dispatch. Mark worker free during Update
        case when phase = 'Dispatch' and queue != '' and position('.' in worker_jobs) != 0 then
                regexp_replace(worker_jobs, '\.', queue)
            when phase = 'Update' then
                (select string_agg(case when worker_time[i] = 0 then '.' else substring(worker_jobs, i, 1) end, '')
                    from generate_series(1, length(worker_jobs)) as i)
            else worker_jobs end,
        -- worker_time: Count down clocks during Tick, set initial job time during Dispatch
        case when phase = 'Tick' then
                (select array_agg(greatest(0, worker_time[i] - 1))
                    from generate_series(1, length(worker_jobs)) as i)
            when phase = 'Dispatch' and queue != '' then
                (select array_agg(case when i = position('.' in worker_jobs) then ascii(queue) - 64
                    else worker_time[i] end)
                    from generate_series(1, length(worker_jobs)) as i)
            else worker_time end
    from next_step
    where length(done) < (select count(*) from steps)  -- Terminate when we've done all steps
)
select * from next_step;
--select count(*) from next_step where phase = 'Tick';
