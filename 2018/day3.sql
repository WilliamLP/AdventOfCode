-- Bash run time: 0m1.440s

-- Parsing
create temporary table parsed as
with regex as (
    select id,
        regexp_split_to_array(str, '[^0-9]+') as arr
    from day3
)
select arr[2]::INT as id, arr[3]::INT as x, arr[4]::INT as y, arr[5]::INT as sx, arr[6]::INT as sy
from regex;

-- Table with row for each x,y position of each patch
create temporary table unrolled as
with counters as (
    select seq1.id,
        seq1.x,
        seq1.y,
        generate_series(1, seq1.sx) as i,
        seq2.j
    from parsed seq1
    join (
        select id, generate_series(1, sy) as j from parsed
    ) as seq2 on (seq2.id = seq1.id)
)
select id, x+i-1 as x, y+j-1 as y
from counters;

-- Part 1
create temporary table tile_counts as (
    select x, y, count(*) as count from unrolled group by 1,2
);

select count(*) from tile_counts where count > 1;

-- Part 2
with max_counts as (
    select unrolled.id, max(tile_counts.count) as count
    from unrolled
    join tile_counts on (tile_counts.x = unrolled.x and tile_counts.y = unrolled.y)
    group by 1
)
select id
from max_counts
where max_counts.count = 1;