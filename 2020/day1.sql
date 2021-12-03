select t1.str, t2.str, (t1.str::int) * (t2.str::int) as answer
from day1 t1
join day1 t2 on ((t1.str::int) + (t2.str::int) = 2020)
limit 1;

select t1.str, t2.str, t3.str, (t1.str::int) * (t2.str::int) * (t3.str::int) as answer
from day1 t1
join day1 t2 on ((t1.str::int) + (t2.str::int) < 2020)
join day1 t3 on ((t1.str::int) + (t2.str::int) + (t3.str::int)) = 2020
limit 1;