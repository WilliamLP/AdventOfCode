-- 970,916 -> 100,46
WITH parsed AS (
    SELECT regexp_match(str, '^(\d+),(\d+) -> (\d+),(\d+)') AS coord FROM day5
), coords AS (
    SELECT coord[1]::INT x1, coord[2]::INT y1, coord[3]::INT x2, coord[4]::INT y2 FROM parsed
), vectors AS (
    SELECT x1, y1, sign(x2-x1) AS dx, sign(y2-y1) AS dy,
        GREATEST(ABS(x1-x2), ABS(y1-y2)) AS length
    FROM coords
), points AS (
    SELECT x1 + i * dx AS x,
        y1 + i * dy AS y,
        dx * dy != 0 AS is_diag
    FROM vectors, generate_series(0, length) AS i
), multiples_part1 AS (
    SELECT x, y FROM points WHERE NOT is_diag
    GROUP BY x, y HAVING COUNT(*) > 1
), multiples_part2 AS (
    SELECT x, y FROM points
    GROUP BY x, y HAVING COUNT(*) > 1
)
SELECT (SELECT COUNT(*) FROM multiples_part1) AS part1_answer,
    (SELECT COUNT(*) FROM multiples_part2) AS part2_answer;
