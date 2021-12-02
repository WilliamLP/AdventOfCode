-- Part 1
WITH parsed AS (
    SELECT split_part(str, ' ', 1) AS cmd,
        split_part(str, ' ', 2)::INT AS steps
    FROM day2
), moves AS (
    SELECT
        CASE WHEN cmd = 'forward' THEN steps ELSE 0 END AS dx,
        CASE WHEN cmd = 'down' THEN steps
            WHEN cmd = 'up' THEN -steps
            ELSE 0 END AS dy
    FROM parsed
)
SELECT sum(dx), sum(dy), sum(dx) * sum(dy) AS part_1_answer
FROM moves;

-- Part 2
WITH parsed AS (
    SELECT id,
        split_part(str, ' ', 1) AS cmd,
        split_part(str, ' ', 2)::INT AS arg
    FROM day2
), delta_aim AS (
    SELECT id, cmd, arg,
        CASE WHEN cmd = 'down' THEN arg
             WHEN cmd = 'up' THEN -arg
             ELSE 0 END AS delta_aim
    FROM parsed
), aim AS (
    SELECT id, cmd, arg,
        SUM(delta_aim) OVER (ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS aim
    FROM delta_aim
), deltas AS (
    SELECT id, cmd, arg, aim,
        CASE WHEN cmd = 'forward' THEN arg ELSE 0 END AS dx,
        CASE WHEN cmd = 'forward' THEN arg * aim ELSE 0 END AS dy
    FROM aim
)
SELECT sum(dx), sum(dy), sum(dx) * sum(dy) AS part_2_answer
FROM deltas;