
WITH parsed AS (
    SELECT REGEXP_EXTRACT_ALL(input, r'(\d+)') AS vals
    FROM day4
), ranges AS (
    SELECT CAST(vals[OFFSET(0)] AS INT) min1, CAST(vals[OFFSET(1)] AS INT) max1,
        CAST(vals[OFFSET(2)] AS INT) min2, CAST(vals[OFFSET(3)] AS INT) max2
    FROM parsed
)
SELECT COUNTIF((min1 >= min2 AND max1 <= max2) OR (min2 >= min1 AND max2 <= max1)) AS part1,
    COUNTIF(max1 >= min2 AND min1 <= max2) AS part2
FROM ranges