select * from day02;

WITH stripped AS (
    SELECT row_num AS game_id, regexp_replace(input, '^Game \d+: ', '') AS game
    FROM day02
), parsed AS (
    SELECT game_id, round
    FROM stripped,
        UNNEST(regexp_split_to_array(game, '; ')) AS arr(round)
), parsed2 AS (
    SELECT
        game_id,
        split_part(info, ' ', 1)::INT AS count,
        split_part(info, ' ', 2) AS color
    FROM parsed,
        UNNEST(regexp_split_to_array(round, ', ')) AS arr(info)
), game_max AS (
    SELECT
        game_id,
        color,
        CASE WHEN color = 'red' THEN 12
            WHEN color = 'green' THEN 13
            WHEN color = 'blue' THEN 14
        END AS lmt,
        MAX(count) AS count
    FROM parsed2
    GROUP BY 1, 2
), part1 AS (
    SELECT SUM(game_id) AS part_1
    FROM stripped
    WHERE game_id NOT IN (
        SELECT DISTINCT game_id
        FROM game_max
        WHERE count > lmt
    )
), color_max AS (
    SELECT
        game_id,
        SUM(CASE WHEN color = 'red' THEN count ELSE 0 END) AS r,
        SUM(CASE WHEN color = 'green' THEN count ELSE 0 END) AS g,
        SUM(CASE WHEN color = 'blue' THEN count ELSE 0 END) AS b
    FROM game_max
    GROUP BY 1
), part2 AS (
    SELECT SUM(r * g * b) AS part_1
    FROM color_max
)
SELECT *
FROM part1, part2;
