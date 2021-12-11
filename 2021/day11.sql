WITH RECURSIVE parsed AS (
    SELECT array_agg(cell) as board FROM (
        SELECT regexp_split_to_table(str, '')::INT AS cell
        FROM day11 ORDER BY row_id
    ) c
), adjacencies AS (
    SELECT (y - 1) * 10 + (x - 1) + 1 AS i, (y - 1 + dy) * 10 + (x - 1 + dx) + 1 AS i_adj
    FROM generate_series(1 , 10) AS x,
        generate_series(1, 10) AS y,
        generate_series(-1, 1) AS dx,
        generate_series(-1, 1) AS dy
    WHERE ((x + dx) BETWEEN 1 AND 10) AND ((y + dy) BETWEEN 1 AND 10)
), board_state(i, step, board) AS (
    SELECT 1, 0, board FROM parsed
    UNION ALL
    SELECT i+1,
        CASE WHEN (SELECT bool_and(cell_lt_10) FROM
            (SELECT cell < 10 AS cell_lt_10 FROM unnest(board) AS cell) AS brd
        ) THEN step + 1 ELSE step END,
        -- ADVANCE BOARD STATE:
        -- Case 1: All cells < 10 ==> grow and advance step
        CASE WHEN (SELECT bool_and(cell_lt_10)
            FROM (SELECT cell < 10 AS cell_lt_10 FROM unnest(board) AS cell) AS brd
        ) THEN (
            (SELECT array_agg(cell + 1)
                FROM (SELECT cell FROM unnest(board) AS cell) AS brd
            )
        -- Case 2: At least one cell = 10 ==> explode, may repeat
        ) WHEN (SELECT bool_or(cell_eq_10)
            FROM (SELECT cell = 10 AS cell_eq_10 FROM unnest(board) AS cell) AS brd
        ) THEN (
            (SELECT array_agg(cell ORDER BY i)
                -- Make sure cells increment to exactly 10, then mark 11 to not re-explode
                FROM (SELECT brd2.i, CASE WHEN cell >= 10 THEN 11
                        ELSE LEAST(cell + sum((board[adj.i_adj] = 10)::INT)::INT, 10) END AS cell
                    FROM (SELECT cell, i from unnest(board) WITH ORDINALITY AS brd1(cell, i)) AS brd2
                    JOIN adjacencies adj ON (adj.i = brd2.i)
                    GROUP BY brd2.i, brd2.cell) AS brd3
            )
        -- Case 3: Reset >= 10 to 0
        ) ELSE (
            (SELECT array_agg(cell)
                FROM (SELECT CASE WHEN cell >= 10 THEN 0 ELSE cell END FROM unnest(board) AS brd(cell)) AS brd2
            )
        ) END
    FROM board_state
    WHERE (
        (SELECT bool_or(cell_gt_0)
        FROM (SELECT cell > 0 AS cell_gt_0 FROM unnest(board) AS cell) AS brd)
    )
), part1 AS (
    SELECT COUNT(*) AS part1_answer
    FROM board_state, unnest(board) AS cell WHERE cell = 0 AND step <= 101
), part2 AS (
    SELECT MAX(step) AS part2_answer FROM board_state
)
SELECT part1_answer, part2_answer FROM part1, part2;

--SELECT i, step, j + 1, board[10*j + 1:10*j + 10]
--FROM board_state, generate_series(0,9) AS j WHERE step <= 2;

