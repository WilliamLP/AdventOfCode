-- Part 1
WITH width AS (
    SELECT char_length(str) AS width
    FROM day3
    LIMIT 1
), pos AS (
    SELECT str,
        (((id-1) * 3) % width) + 1 AS pos
    FROM day3
    CROSS JOIN width
)
SELECT COUNT(*) FROM pos
WHERE substring(str FROM pos FOR 1) = '#';

-- Part 2
WITH width AS (
    SELECT char_length(str) AS width
    FROM day3
    LIMIT 1
), pos AS (
    SELECT str,
        (((id-1) * 1) % width) + 1 AS pos1,
        (((id-1) * 3) % width) + 1 AS pos3,
        (((id-1) * 5) % width) + 1 AS pos5,
        (((id-1) * 7) % width) + 1 AS pos7,
        CASE WHEN (id % 2) = 1 THEN (((id-1) / 2) % width) + 1
            ELSE 0 END AS poshalf
    FROM day3
    CROSS JOIN width
), counts AS (
    SELECT SUM((substring(str FROM pos1 FOR 1) = '#')::INT) AS count1,
        SUM((substring(str FROM pos3 FOR 1) = '#')::INT) AS count3,
        SUM((substring(str FROM pos5 FOR 1) = '#')::INT) AS count5,
        SUM((substring(str FROM pos7 FOR 1) = '#')::INT) AS count7,
        SUM((poshalf != 0 AND substring(str FROM poshalf FOR 1) = '#')::INT) AS counthalf
    FROM pos
)
SELECT count1 * count3 * count5 * count7 * counthalf
FROM counts;