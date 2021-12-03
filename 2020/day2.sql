DROP TABLE IF EXISTS day2_parsed;
CREATE TABLE day2_parsed AS
WITH split AS (
    SELECT regexp_match(str, '^(\d+)-(\d+) (\w): (\w+)$') as m
    FROM day2
)
SELECT m[1]::int as lo, m[2]::int as hi, m[3] as ch, m[4] as pass
from split;

-- Part 1
WITH processed AS (
    SELECT *,
        array_length(string_to_array(pass, ch), 1) - 1 AS hits
    FROM day2_parsed
)
SELECT COUNT(*) as answer
FROM processed
WHERE hits >= lo AND hits <= hi;

-- Part 2
SELECT COUNT(*)
FROM day2_parsed
WHERE ((substring(pass FROM lo FOR 1) = ch)::INT) +
    ((substring(pass FROM hi FOR 1) = ch)::INT) = 1;



