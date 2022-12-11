WITH RECURSIVE parsed AS (
    SELECT row_num, split_part(input, ' ', 1) AS instr, split_part(input, ' ', 2)::int AS arg
    FROM day10
), state AS (
    SELECT 0 AS cycle_from, 0 AS cycle_to, 0 AS instr_num, 1 AS prev_x, 1 AS x
    UNION ALL
    SELECT cycle_to, cycle_to + CASE WHEN instr = 'noop' THEN 1 ELSE 2 END,
        instr_num + 1,
        x, CASE WHEN instr = 'addx' THEN x + arg ELSE x END
    FROM state
    JOIN parsed ON (row_num = instr_num + 1)
), test_cycles AS (
    SELECT 20 + 40 * i AS cycle
    FROM generate_series(0, 5) AS i
), part1 AS (
    SELECT SUM(cycle * prev_x) AS part1
    FROM test_cycles
    JOIN state ON (cycle BETWEEN cycle_from + 1 AND cycle_to)
), crt AS (
    SELECT row, col, CASE WHEN abs(prev_x - col) <= 1 THEN '#' ELSE '.' END AS ch
    FROM generate_series(1, 6) AS row
    CROSS JOIN generate_series(0, 39) AS col
    JOIN state ON ((row - 1) * 40 + col BETWEEN cycle_from AND cycle_to - 1)
), part2 AS (
    SELECT string_agg(ch, '' ORDER BY col) AS crt_row
    FROM crt
    GROUP BY row
)
SELECT * FROM part1, part2;