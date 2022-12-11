WITH RECURSIVE cmds AS (
    SELECT SPLIT_PART(input, ' ', 1) AS dir,
        ROW_NUMBER() OVER(ORDER BY row_num, i) AS cmd_num
    FROM day9_test, GENERATE_SERIES(1, SPLIT_PART(input, ' ', 2)::INT) AS i
), dirs AS (
    SELECT 'U' AS dir, 0 AS dx, -1 AS dy
    UNION ALL SELECT 'D', 0, 1
    UNION ALL SELECT 'L', -1, 0
    UNION ALL SELECT 'R', 1, 0
), moves AS (
    SELECT 0 AS hx, 0 AS hy, 0 AS tx, 0 AS ty, 0 AS cmd_num
    UNION ALL
    SELECT hx + dx, hy + dy,
        CASE WHEN GREATEST(ABS(hx + dx - tx), ABS(hy + dy - ty)) > 1
            THEN tx + SIGN(hx - tx)::INT ELSE tx END,
        CASE WHEN GREATEST(ABS(hx + dx - tx), ABS(hy + dy - ty)) > 1
            THEN ty + SIGN(hy - ty)::INT ELSE ty END,
        moves.cmd_num + 1
    FROM moves
    JOIN cmds ON (cmds.cmd_num = moves.cmd_num + 1)
    JOIN dirs ON (dirs.dir = cmds.dir)
)
SELECT count(distinct (tx, ty)) AS part1 FROM moves;