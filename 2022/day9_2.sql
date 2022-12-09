WITH RECURSIVE cmds AS (
    SELECT SPLIT_PART(input, ' ', 1) AS dir,
        ROW_NUMBER() OVER(ORDER BY row_num, i) AS cmd_num
    FROM day9, GENERATE_SERIES(1, SPLIT_PART(input, ' ', 2)::INT) AS i
), dirs AS (
    SELECT 'U' AS dir, 0 AS dx, -1 AS dy
    UNION ALL SELECT 'D', 0, 1
    UNION ALL SELECT 'L', -1, 0
    UNION ALL SELECT 'R', 1, 0
), moves AS (
    SELECT 0 AS cmd_num, 1 AS segment_num, 0 AS x, 0 AS y
    UNION ALL
    -- In the same query, calculate next move for segment 1, and segment pos for each other segment based on previous segment.
    -- Note the crazy diagonalization is because for a given segment, turn we need both the previous segment from the same turn,
    -- and the same segment from the previous turn in the same query result! (No self-join in the recursive table in PSQL)
    SELECT CASE WHEN mode = 'next cmd' THEN moves.cmd_num + 1 ELSE moves.cmd_num END,
        CASE WHEN mode = 'next cmd' THEN segment_num ELSE segment_num + 1 END,
        CASE WHEN mode = 'next segment' THEN 0
            WHEN mode = 'next cmd' AND segment_num = 1 THEN x + dx
            ELSE (
                CASE WHEN GREATEST(ABS(LAG(x) OVER prev_segment - x), ABS(LAG(y) OVER prev_segment - y)) > 1
                    THEN x + SIGN(LAG(x) OVER prev_segment - x)::INT ELSE x
                END) END,
        CASE WHEN mode = 'next segment' THEN 0
            WHEN mode = 'next cmd' AND segment_num = 1 THEN y + dy
            ELSE (
                CASE WHEN GREATEST(ABS(LAG(x) OVER prev_segment - x), ABS(LAG(y) OVER prev_segment - y)) > 1
                         THEN y + SIGN(LAG(y) OVER prev_segment - y)::INT ELSE y
                END) END
    FROM moves
    LEFT JOIN cmds ON (cmds.cmd_num = moves.cmd_num + 1)
    LEFT JOIN dirs ON (dirs.dir = cmds.dir)
    CROSS JOIN (SELECT 'next cmd' AS mode UNION ALL select 'next segment') AS mode
    -- Run 1 extra iteration to pad the end, so the result sets will always have 2 rows to work with
    WHERE (mode = 'next cmd' AND moves.cmd_num <= (SELECT COUNT(*) FROM cmds)) OR
        (mode = 'next segment' AND moves.cmd_num = 0 AND segment_num < 10)
    WINDOW prev_segment AS (ORDER BY segment_num)
)
SELECT COUNT(DISTINCT (x, y)) FILTER(WHERE segment_num = 2) AS part1,
    COUNT(DISTINCT (x, y)) FILTER(WHERE segment_num = 10) AS part2
FROM moves;