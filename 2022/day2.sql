WITH parsed AS (
    -- 1, 2, 3 => Rock, Paper, Scissors || Lost, Draw, Win
    SELECT ascii(substr(input, 1, 1)) - ascii('A') + 1 AS opp_move,
        ascii(substr(input, 3, 1)) - ascii('X') + 1 AS my_move
    FROM day2
), game_score AS (
    SELECT my_move AS my_move1,
        CASE
            WHEN my_move - opp_move IN (1, -2) THEN 6
            WHEN my_move = opp_move THEN 3
            ELSE 0
        END AS score1,
        CASE WHEN my_move = 1 THEN IF(opp_move = 1, 3, opp_move - 1) -- Lose
            WHEN my_move = 2 THEN opp_move
            WHEN my_move = 3 THEN IF(opp_move = 3, 1, opp_move + 1) -- Win
        END AS my_move2,
        my_move * 3 - 3 AS score2
    FROM parsed
)
SELECT SUM(my_move1 + score1) AS part1, SUM(my_move2 + score2) AS part2
FROM game_score;