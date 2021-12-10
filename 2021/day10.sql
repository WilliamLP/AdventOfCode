WITH RECURSIVE reduced AS (
    SELECT row_id, str FROM day10
    UNION
    SELECT row_id, regexp_replace(str, '(\[\])|(\(\))|(\{\})|(\<\>)', '', 'g') FROM reduced
), shortest AS (
    SELECT DISTINCT ON (row_id) row_id, str FROM reduced ORDER BY row_id, length(str)
), detect_invalid AS (
    SELECT row_id, str, (regexp_match(str, '[\)\]\}\>]'))[1] AS invalid FROM shortest
), part1 AS (
    SELECT SUM(CASE WHEN invalid = ')' THEN 3
        WHEN invalid = ']' THEN 57
        WHEN invalid = '}' THEN 1197
        WHEN invalid = '>' THEN 25137 ELSE 0 END) AS part1_answer FROM detect_invalid
), chars_to_close AS (
    SELECT row_id, pos, char
    FROM detect_invalid, unnest(regexp_split_to_array(str, '')) WITH ORDINALITY AS chars(char, pos)
    WHERE invalid IS NULL
), scores AS (
    SELECT row_id, sum((5^(pos-1)) * CASE WHEN char = '(' THEN 1
        WHEN char = '[' THEN 2
        WHEN char = '{' THEN 3
        WHEN char = '<' THEN 4 END) AS score,
        row_id FROM chars_to_close GROUP BY 1
), part2 AS (
    SELECT percentile_disc(0.5) WITHIN GROUP (ORDER BY score) AS part2_answer FROM scores
)
SELECT part1_answer, part2_answer FROM part1, part2
