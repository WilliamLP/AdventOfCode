WITH stripped as (
    SELECT regexp_replace(input, '[a-z]', '', 'g') AS str
    FROM day01
)
SELECT SUM((left(str, 1) || right(str, 1))::INT) AS part1
FROM stripped;

WITH RECURSIVE digit_map AS (
    SELECT
        '{one,two,three,four,five,six,seven,eight,nine}'::TEXT[] AS strs,
        ARRAY((SELECT generate_series(1, 9))) AS digits
), translated(input, i, d, first, last) AS (
    SELECT input, 1, 1, NULL::INT, NULL::INT
    FROM day01

    UNION ALL

    SELECT
        input,
        CASE WHEN d < 9 THEN i ELSE i + 1 END,
        CASE WHEN d < 9 THEN d + 1 ELSE 1 END,
        CASE
            WHEN first IS NOT NULL THEN first
            WHEN starts_with(substring(input, i), strs[d]) THEN digits[d]
            WHEN substring(input, i, 1) = digits[d]::TEXT THEN digits[d]
        END,
        CASE
            WHEN last IS NOT NULL THEN last
            WHEN starts_with(substring(input, length(input) - i), strs[d]) THEN digits[d]
            WHEN substring(input, length(input) + 1 - i, 1) = digits[d]::TEXT THEN digits[d]
        END
    FROM translated, digit_map
    WHERE (first IS NULL OR LAST IS NULL)
)
SELECT SUM(first * 10 + last) AS part2
FROM translated
WHERE first IS NOT NULL AND last IS NOT NULL;
