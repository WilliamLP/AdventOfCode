WITH positions AS (
    SELECT regexp_split_to_table(str, ',')::INT AS n FROM day7
), centers AS (
    SELECT generate_series(min(n), max(n)) AS center FROM positions
), fuel_for_center AS (
    SELECT SUM(ABS(n - center)) AS fuel_1,
        SUM((n - center) * (n - center) + ABS(n - center)) / 2 AS fuel_2
    FROM positions, centers
    GROUP BY center
)
SELECT MIN(fuel_1) AS part1_answer, MIN(fuel_2) AS part2_answer FROM fuel_for_center;