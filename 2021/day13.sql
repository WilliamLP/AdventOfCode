WITH RECURSIVE folds AS (
    SELECT row_number() OVER () AS step, match[1] AS axis, match[2]::INT AS value
    FROM (SELECT regexp_match(str, 'fold along ([xy])=(\d+)') FROM day13) AS _(match)
    WHERE match IS NOT NULL
), coords AS (
    SELECT 0 AS step, coord[1]::INT AS x, coord[2]::INT AS y
    FROM (SELECT regexp_match(str, '(\d+),(\d+)') FROM day13) AS _(coord)
    WHERE coord IS NOT NULL
    UNION ALL
    SELECT DISTINCT coords.step + 1,
        CASE WHEN axis = 'y' OR axis = 'x' AND value > coords.x THEN x
            ELSE value - (coords.x - value) END,
        CASE WHEN axis = 'x' OR axis = 'y' AND value > coords.y THEN y
            ELSE value - (coords.y - value) END
    FROM coords
    JOIN folds ON (folds.step = coords.step + 1)
    WHERE coords.step < (SELECT COUNT(*) FROM folds)
), part1 AS (
    SELECT COUNT(*) AS part1_answer FROM coords WHERE step = 1
), bounds AS (
    SELECT max(x) AS max_x, max(y) AS max_y, max(step) AS max_step
    FROM coords WHERE step = (SELECT max(step) FROM coords)
), part2 AS (
    SELECT string_agg(CASE WHEN coords.x IS NULL THEN '.' ELSE '#' END, '') AS part2_display
    FROM (SELECT generate_series(0, max_x) sx FROM bounds) AS sx
    CROSS JOIN (SELECT generate_series(0, max_y) sy FROM bounds) AS sy
    LEFT JOIN coords ON (coords.x = sx AND coords.y = sy AND coords.step = (SELECT max_step FROM bounds))
    GROUP BY sy
)
SELECT part1_answer::TEXT FROM part1
UNION ALL SELECT part2_display FROM part2;