-- Setup

-- Table with one row for every character in every string
create temporary table chars (
    id int,
    i int,
    chr char(1)
);

with pos as (
    select id, str, generate_series(1, length(str)) as i
    from day2
)
insert into chars(id, i, chr)
select id, i, substring(str, i, 1)
from pos;

-- Part 1

with counts as (
    select id, chr, count(*)
    from chars
    group by 1,2
), by_count as (
    select count, count(distinct id) as num_seqs
    from counts
    group by 1
), pairs as (
    select num_seqs from by_count where count = 2
), triples as (
    select num_seqs from by_count where count = 3
)
select pairs.num_seqs, triples.num_seqs, pairs.num_seqs * triples.num_seqs as result
from pairs join triples on (true);

-- Part 2

-- numbers of differences between any two sequences, pairwise
with diffs as (
    select chars1.id as id1, chars2.id as id2, count(*) as diffs, min(chars1.i) as diff_pos
    from chars chars1
    join chars chars2 on (chars2.id > chars1.id AND chars2.i = chars1.i)
    where chars1.chr != chars2.chr
    group by 1,2
)
select substring(seq.str, 1, diff_pos - 1) || substring(seq.str, diff_pos + 1) as result
from diffs
join day2 seq on (seq.id = diffs.id1)
where diffs.diffs = 1;