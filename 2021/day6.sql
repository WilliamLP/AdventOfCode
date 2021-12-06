WITH RECURSIVE transitions AS (
    SELECT generate_series(1, 8) AS timer, generate_series(0, 7) AS timer_to
    UNION SELECT 0, 6 UNION SELECT 0, 8
),  fish(day, timer, count) AS (
    SELECT 0, timer, COUNT(*) AS count FROM (
        SELECT regexp_split_to_table(str, ',')::INT AS timer FROM day6
    ) first_day GROUP BY 1,2
    UNION ALL
    SELECT day, timer, SUM(count)::BIGINT FROM (
        SELECT day + 1 AS day, timer_to AS timer, count
        FROM fish JOIN transitions USING(timer)
    ) next_day WHERE day <= 256 GROUP BY 1,2
)
SELECT (SELECT SUM(count) FROM fish WHERE day = 80) AS part1_answer,
    (SELECT SUM(count) FROM fish WHERE day = 256) AS part2_answer;