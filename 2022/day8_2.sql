WITH RECURSIVE parsed AS (
    SELECT ch::int AS height, row_num AS y, i AS x
    FROM day8, UNNEST(REGEXP_SPLIT_TO_ARRAY(input, '')) WITH ORDINALITY AS arr(ch, i)
), unit_vecs AS (
    SELECT -1 AS dx, 0 AS dy UNION ALL SELECT 1, 0 UNION ALL SELECT 0, -1 UNION ALL SELECT 0, 1
), views AS (
    SELECT woods1.x, woods1.y, dx, dy, dist, woods2.height < woods1.height AS is_shorter
    FROM parsed AS woods1
    CROSS JOIN unit_vecs
    CROSS JOIN GENERATE_SERIES(0, (SELECT MAX(x) FROM parsed)) AS dist
    JOIN parsed AS woods2 ON (
        woods2.x = woods1.x + dist * dx AND woods2.y = woods1.y + dist * dy)
), max_dist AS (
    SELECT x, y, dx, dy, MAX(dist) AS max_dist
    FROM views v
    GROUP BY x, y, dx, dy
), clear_views AS (
    SELECT x, y, dx, dy, BOOL_OR(dist > 0 AND NOT is_shorter) AS obstructed
    FROM views
    GROUP BY 1, 2, 3, 4
), any_clear_view AS (
    SELECT x, y
    FROM clear_views
    GROUP BY 1, 2 HAVING NOT BOOL_AND(obstructed)
), first_tree_dist AS (
    SELECT x, y, dx, dy, MIN(dist) FILTER (WHERE dist > 0) AS first_tree_dist
    FROM views
    WHERE NOT is_shorter
    GROUP BY 1, 2, 3, 4
), part2_score_arr AS (
    SELECT t.x, t.y, ARRAY_AGG(COALESCE(first_tree_dist, max_dist)) AS arr
    FROM first_tree_dist t
    JOIN max_dist md ON (md.x = t.x AND md.y = t.y AND md.dx = t.dx AND md.dy = t.dy)
    GROUP BY 1, 2
)
SELECT (SELECT COUNT(*) FROM any_clear_view) AS part1,
    (SELECT MAX(arr[1] * arr[2] * arr[3] * arr[4]) FROM part2_score_arr) AS part2
