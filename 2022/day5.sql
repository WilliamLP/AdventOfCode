WITH RECURSIVE config_end AS (
    SELECT row_num FROM day5 WHERE input LIKE ' 1%'
), parsed_config AS (
    SELECT day5.row_num, ch AS crate, FLOOR(i/4) AS stack_num
    FROM day5, config_end,
        UNNEST(REGEXP_SPLIT_TO_ARRAY(input, '')) WITH ORDINALITY AS arr(ch, i)
    WHERE day5.row_num < config_end.row_num AND MOD(i, 4) = 2
), init_stacks AS (
    SELECT stack_num, STRING_AGG(crate, '' ORDER BY row_num DESC) AS stack
    FROM parsed_config
    WHERE crate != ' '
    GROUP BY stack_num
), parsed_moves AS (
    SELECT day5.row_num - config_end.row_num - 1 AS move_num,
        REGEXP_MATCH(input, '^move (\d+) from (\d+) to (\d+)') AS vals
    FROM day5, config_end
    WHERE day5.row_num > config_end.row_num + 1
), moves AS (
    SELECT move_num, vals[1]::INT AS count, vals[2]::INT AS src, vals[3]::INT as dest
    FROM parsed_moves
), stacks AS (
    SELECT part, 0 AS move_num,
        ARRAY_AGG(stack ORDER BY stack_num) AS arr
    FROM init_stacks, (SELECT 1 AS part UNION SELECT 2) AS parts
    GROUP BY part
    UNION ALL
    SELECT part, stacks.move_num + 1 AS move_num, (
        SELECT ARRAY_AGG(CASE
            WHEN i = src THEN LEFT(stack, LENGTH(stack) - count)
            WHEN i = dest THEN stack ||
                CASE
                    WHEN part = 1 THEN REVERSE(RIGHT(arr[src], count))
                    WHEN part = 2 THEN RIGHT(arr[src], count)
                END
            ELSE stack
        END)
        FROM UNNEST(arr) WITH ORDINALITY AS a(stack, i)
    ) AS arr
    FROM stacks JOIN moves ON (moves.move_num = stacks.move_num + 1)
)
SELECT 'Part ' || part, STRING_AGG(RIGHT(stack, 1), '')
FROM stacks, UNNEST(arr) AS stack
WHERE move_num = (SELECT MAX(move_num) FROM stacks)
GROUP BY part


