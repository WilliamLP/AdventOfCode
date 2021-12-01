-- Bash runtime: 0m0.065s

-- Setup

create temporary table events (
    id int primary key,
    str text,
    type text,
    time timestamp,
    last_on_duty_at timestamp,
    last_on_duty_id int,
    last_sleep_at timestamp
);

insert into events(id, str, time)
select id, str, substring(str, 2, 16)::timestamp
from day4;

update events
set type = case
    when str like '%wakes up%' then 'Wake'
    when str like '%falls asleep%' then 'Sleep'
    else 'On Duty' end;

-- Find last on duty
with on_duty as (
    select id,
        max(case when type = 'On Duty' then time else '0001-01-01'::date end)
            over (order by time) as last
    from events
)
update events
set last_on_duty_at = on_duty.last
from on_duty
where on_duty.id = events.id;

-- Which guard was it?
update events e1
set last_on_duty_id = (regexp_match(e2.str, 'Guard #(\d+) begins shift'))[1]::INT
from events e2
where e2.type = 'On Duty' AND e2.time = e1.last_on_duty_at;

-- When did naps start?
with sleep as (
    select id,
        max(case when type = 'Sleep' then time else '0001-01-01'::date end)
            over (order by time) as last
    from events
)
update events
set last_sleep_at = sleep.last
from sleep
where sleep.id = events.id and events.type = 'Wake';

-- Table with row for every minute someone was sleeping. Count down from wake time.
create temporary table sleep_minutes AS
with sleep_counter AS (
    select last_on_duty_id as id,
        time as wake_at,
        generate_series(1, ((extract(epoch from time) - extract(epoch from last_sleep_at)) / 60)::INT) as i
    from events
    where type = 'Wake'
)
select id, wake_at - (i * '1 minute'::INTERVAL) as time
from sleep_counter;

-- Part 1
with mins_slept as (
    select id, count(*) as mins
    from sleep_minutes
    group by 1
), slept_most as (
    select id
    from mins_slept
    order by mins desc
    limit 1
), max_minute as (
    select extract(minute from smins.time) as minute, count(*) as count
    from sleep_minutes smins
    join slept_most smost ON (true)
    where smost.id = smins.id
    group by 1
    order by 2 desc
    limit 1
)
select sm.id, mm.minute, sm.id * mm.minute as result
from slept_most sm
join max_minute mm on (true);

-- Part 2 (now trivial!)
with max_minute as (
    select id, extract(minute from time) as minute, count(*)
    from sleep_minutes
    group by 1,2
    order by 3 desc
    limit 1
)
select id, minute, id * minute as result from max_minute;