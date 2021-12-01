-- Bash run time: 0m0.477s

-- Setup

-- drop table if exists freq;
create temporary table freq (
    id int primary key,
    delta int,
    cumulative_total int
);

insert into freq (id, delta) select id, str::INT from day1;

with totals as (
    select f.id, sum(f2.delta) as total
    from freq f
    join freq f2 on (f2.id <= f.id)
    group by 1
)
update freq set cumulative_total = total
from totals
where totals.id = freq.id;

-- Part 1

select sum(delta) from freq;

-- Part 2

with grand_total as (select sum(delta) as total from freq),
cycled as (
    -- Simulate cycling over the list 1000 times.
    select cumulative_total + i * grand_total.total as cumulative_total,
        i, freq.id
    from freq
    join (select generate_series(0,200) as i) as series on (true)
    join grand_total on (true)
), ranks as (
    -- Find the second sequence number that led to a given total.
    select cumulative_total, i, id,
        row_number() over (partition by cumulative_total order by i, id) as rank
    from cycled
)
-- Final answer is the first row in the sequence that we hit twice.
select cumulative_total, i, id from ranks where rank = 2 order by i, id limit 1;
