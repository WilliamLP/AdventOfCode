-- Part 1
WITH vals AS (
    SELECT str::INT AS val,
        lag(str::INT) OVER (ORDER BY id) AS prev_val
    FROM day1
)
SELECT COUNT(*)
FROM vals
WHERE val > prev_val;

-- Part 2
WITH windows AS (
    SELECT id,
        SUM(str::INT) OVER (ORDER BY id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS val
    FROM day1
), vals AS (
    SELECT val,
        lag(val) OVER (ORDER BY id) AS prev_val
    FROM windows
    WHERE id >= 3
)
SELECT COUNT(*)
FROM vals
WHERE val > prev_val;
