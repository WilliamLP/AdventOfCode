WITH RECURSIVE parsed AS (
    SELECT ch::int AS height, row_num AS y, i AS x
    FROM day8, UNNEST(REGEXP_SPLIT_TO_ARRAY(input, '')) WITH ORDINALITY AS arr(ch, i)
), windows AS (
    SELECT x, y, height,
        MAX(height) OVER (PARTITION BY y ORDER BY x ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS height_left,
        MAX(height) OVER (PARTITION BY y ORDER BY x DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS height_right,
        MAX(height) OVER (PARTITION BY x ORDER BY y ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS height_up,
        MAX(height) OVER (PARTITION BY x ORDER BY y DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS height_down
    FROM parsed
), part1 AS (
    SELECT COUNT(*) FROM windows
    WHERE height > COALESCE(height_left, -1) OR height > COALESCE(height_right, -1) OR
        height > COALESCE(height_up, -1) OR height > COALESCE(height_down, -1)
), unit_vecs AS (
    SELECT -1 AS dx, 0 AS dy UNION ALL SELECT 1, 0 UNION ALL SELECT 0, -1 UNION ALL SELECT 0, 1
), views AS (
    SELECT x, y, height, dx, dy, 0 AS dist, FALSE AS is_done
    FROM parsed, unit_vecs
    UNION ALL
    SELECT views.x, views.y, views.height, dx, dy, dist + 1, parsed.height >= views.height
    FROM views
    JOIN parsed ON (parsed.x = views.x + (dist + 1) * dx AND parsed.y = views.y + (dist + 1) * dy)
    WHERE NOT is_done
), trees_seen AS (
    SELECT x, y, dx, dy, COUNT(*) - 1 AS trees_seen
    FROM views
    GROUP BY 1, 2, 3, 4
), scores AS (
    SELECT x, y, ARRAY_AGG(trees_seen ORDER BY dx, dy) AS arr
    FROM trees_seen
    GROUP BY 1,2
), part2 AS (
    SELECT MAX(arr[1] * arr[2] * arr[3] * arr[4]) FROM scores
)
SELECT * from part1, part2;