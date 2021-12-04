DROP TABLE IF EXISTS day4_draws;
CREATE TABLE day4_draws AS
SELECT ordinality AS draw_num, draw
FROM day4, unnest(string_to_array(str, ',')) WITH ORDINALITY AS draw
WHERE id = 1;

DROP TABLE IF EXISTS day4_boards;
CREATE TABLE day4_boards AS
WITH board_str AS (
    SELECT (id - 3) / 6 AS board_num, string_agg(str, ' ') AS board_str
    FROM day4
    WHERE id >= 3
    GROUP BY 1
)
SELECT board_num, (ordinality - 1)::INT AS pos, cell
FROM board_str, unnest(regexp_split_to_array(trim(board_str), '\s+')) WITH ORDINALITY AS cell;

CREATE INDEX ON day4_boards(cell);

DROP TABLE IF EXISTS day4_pos_after_draw;
CREATE TABLE day4_pos_after_draw AS
WITH pos_for_draw AS (
    SELECT board_num, draw_num, 1 << pos AS pos_bit
    FROM day4_boards b
    JOIN day4_draws d ON (d.draw = b.cell)
)
SELECT board_num, draw_num,
    bit_or(pos_bit) OVER (
        PARTITION BY board_num ORDER BY draw_num ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        AS pos
FROM pos_for_draw;

DROP TABLE IF EXISTS day4_winning_pos;
CREATE TABLE day4_winning_pos AS
SELECT (1<<n1) + (1<<n2) + (1<<n3) + (1<<n4) + (1<<n5) AS winning_pos
FROM (VALUES
    (0,1,2,3,4), (5,6,7,8,9), (10,11,12,13,14), (15,16,17,18,19), (20,21,22,23,24),
    (0,5,10,15,20), (1,6,11,16,21), (2,7,12,17,22), (3,8,13,18,23), (4,9,14,19,24)
) AS v(n1, n2, n3, n4, n5);

DROP TABLE IF EXISTS day4_win_for_draw;
CREATE TABLE day4_win_for_draw AS
SELECT board_num, draw_num, pos,
    bool_or((pos & winning_pos) = winning_pos) AS is_win
FROM day4_pos_after_draw, day4_winning_pos
GROUP BY board_num, draw_num, pos;

-- Part 1
WITH winning_draw AS (
    SELECT d.draw_num, d.draw
        FROM day4_win_for_draw w
        JOIN day4_draws d ON (d.draw_num = w.draw_num)
        WHERE is_win
        ORDER BY d.draw_num LIMIT 1
), winning_board AS (
    SELECT board_num, pos, (1<<25)-1-pos AS unmarked
    FROM day4_win_for_draw w, winning_draw d
    WHERE d.draw_num = w.draw_num AND is_win
), unpack_unmarked AS (
    SELECT board_num, i
    FROM winning_board, generate_series(0,24) AS i
    WHERE ((1<<i) & unmarked) > 0
)
SELECT SUM(b.cell::INT) * MIN(w.draw::INT) as part_1_answer
FROM day4_boards b
JOIN unpack_unmarked u ON (u.i = b.pos)
CROSS JOIN winning_draw w
WHERE b.board_num = u.board_num;

-- Part 2
WITH winning_draw AS (
    SELECT DISTINCT ON (w.board_num) w.board_num, d.draw_num, d.draw
    FROM day4_win_for_draw w
    JOIN day4_draws d ON (d.draw_num = w.draw_num)
    WHERE is_win
    ORDER BY w.board_num, d.draw_num
), last_winning_board AS (
    SELECT w.draw_num, w.board_num, pos, (1<<25)-1-pos AS unmarked
    FROM day4_win_for_draw w
    JOIN winning_draw d ON (d.board_num = w.board_num AND d.draw_num = w.draw_num)
    ORDER BY 1 DESC LIMIT 1
), unpack_unmarked AS (
    SELECT board_num, i
    FROM last_winning_board, generate_series(0,24) AS i
    WHERE ((1<<i) & unmarked) > 0
)
SELECT SUM(b.cell::INT) * MIN(w.draw::INT) as part_2_answer
FROM day4_boards b
JOIN unpack_unmarked u ON (u.i = b.pos)
JOIN winning_draw w ON (w.board_num = b.board_num)
WHERE b.board_num = u.board_num;


