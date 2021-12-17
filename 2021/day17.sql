WITH RECURSIVE goals AS (
    SELECT parsed, parsed[1]::INT AS goal_min_x, parsed[2]::INT AS goal_max_x,
        parsed[3]::INT AS goal_min_y, parsed[4]::INT AS goal_max_y
    FROM day17, regexp_match(str, 'target area: x=(\d+)\.\.(\d+)\, y=(-?\d+)\.\.(-?\d+)') AS parsed
), vectors (vx0, vy0, x, y, vx, vy, max_y) AS (
    SELECT vx, vy, 0, 0, vx, vy, 0
    FROM goals, generate_series(1, goal_max_x) AS vx, generate_series(goal_min_y, -goal_min_y) AS vy
    UNION ALL
    SELECT vx0, vy0, x + vx, y + vy, GREATEST(0, vx-1), vy - 1, GREATEST(max_y, y + vy)
    FROM vectors, goals
    WHERE x <= goal_max_x AND y >= goal_min_y
), part1 AS (
    SELECT MAX(max_y) AS part1_answer FROM vectors, goals
    WHERE x >= goal_min_x AND x <= goal_max_x AND y >= goal_min_y AND y <= goal_max_y
), part2 AS (
    SELECT COUNT(*) AS part2_answer FROM (
        SELECT vx0, vy0 FROM vectors, goals
        WHERE x >= goal_min_x AND x <= goal_max_x AND y >= goal_min_y AND y <= goal_max_y
        GROUP BY 1,2) AS dist
)
SELECT * FROM part1, part2;




