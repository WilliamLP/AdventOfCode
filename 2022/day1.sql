WITH enumerated AS (
    SELECT IF(input = '', 0, CAST(input AS INT)) as calories,
        COUNTIF(input = '') OVER (
            ORDER BY row_num ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS group_num
    FROM day1
), grouped AS (
    SELECT group_num, SUM(calories) AS total_calories
    FROM enumerated
    GROUP BY 1
)
SELECT MAX(total_calories) AS part_1
FROM grouped
UNION ALL
SELECT SUM(total_calories) AS part_2
FROM (SELECT * FROM grouped ORDER BY total_calories DESC LIMIT 3)
