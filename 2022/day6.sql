WITH parts AS (
    SELECT 1 AS part, 4 as len UNION ALL SELECT 2, 14
), distinct_check AS (
    SELECT part, len, i + j AS pos, COUNT(DISTINCT ch) AS num_distinct
    FROM day6, parts, UNNEST(SPLIT(input, '')) AS ch WITH OFFSET i,
        UNNEST(GENERATE_ARRAY(0, len-1)) AS j
    GROUP BY 1, 2, 3
)
SELECT 'Part ' || part, MIN(pos) + 1
FROM distinct_check
WHERE num_distinct = len
GROUP BY part;