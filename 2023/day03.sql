WITH parsed AS (
    SELECT row_num AS i, j, ch,
        CASE WHEN ch ~ '\d' THEN ch::INT END AS val,
        SUM(CASE WHEN ch ~ '\d' THEN 0 ELSE 1 END)
            OVER (PARTITION BY row_num ORDER BY j ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS num_group_id
    FROM day03,
        UNNEST(regexp_split_to_array(input, '')) WITH ORDINALITY AS arr(ch, j)
), num_groups AS (
    SELECT i, MIN(j) AS min_j, MAX(j) AS max_j,
        STRING_AGG(ch, '')::INT AS val
    FROM parsed
    WHERE val IS NOT NULL
    GROUP BY 1, num_group_id
), symbol_num_groups AS (
    SELECT DISTINCT p2.ch, p2.i, p2.j, ng.i AS ng_i, ng.min_j AS ng_min_j, ng.val
    FROM parsed p1
    JOIN parsed p2 ON (p2.val IS NULL AND p2.ch != '.' AND ABS(p2.j - p1.j) <= 1 AND ABS(p2.i - p1.i) <= 1)
    JOIN num_groups ng ON (ng.i = p1.i AND p1.j BETWEEN ng.min_j AND ng.max_j)
    WHERE p1.val IS NOT NULL
), by_gear AS (
    SELECT i, j, array_agg(val) AS vals
    FROM symbol_num_groups
    WHERE ch = '*'
    GROUP BY 1, 2
), part1 AS (
    -- Assume no number touches two symbols
    SELECT SUM(val) AS part1
    FROM symbol_num_groups
), part2 AS (
    SELECT SUM(vals[1] * vals[2]) AS part2
    FROM by_gear
    WHERE array_length(vals, 1) = 2
)
SELECT *
FROM part1, part2;