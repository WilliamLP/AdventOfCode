CREATE TEMPORARY TABLE pos AS
SELECT regexp_split_to_table(str, ',')::INT AS n FROM day7;

WITH series AS (
    SELECT generate_series(min(n), max(n)) AS center FROM pos
), fuel_for_center AS (
    SELECT SUM(ABS(n - center)) AS fuel_1,
        SUM((n - center) * (n - center) + ABS(n - center)) / 2 AS fuel_2
    FROM pos, series
    GROUP BY center
)
SELECT MIN(fuel_1) AS part1_answer, MIN(fuel_2) AS part2_answer
FROM fuel_for_center;