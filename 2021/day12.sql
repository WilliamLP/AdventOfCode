WITH RECURSIVE adjacencies AS (
    SELECT nodes[1] AS n1, nodes[2] AS n2
    FROM day12, regexp_split_to_array(str, '-') AS nodes
    WHERE nodes[1] != 'end' AND nodes[2] != 'start'
    UNION ALL
    SELECT nodes[2] AS n1, nodes[1] AS n2
    FROM day12, regexp_split_to_array(str, '-') AS nodes
    WHERE nodes[2] != 'end' AND nodes[1] != 'start'
), paths(path, repeat) AS (
    SELECT '{"start"}'::TEXT[], false
    UNION ALL
    SELECT path || n2, repeat OR (array_position(path, n2) IS NOT NULL AND n2 != upper(n2))
    FROM paths JOIN adjacencies ON (n1 = path[cardinality(path)])
    WHERE (n2 = upper(n2)) OR NOT repeat OR (array_position(path, n2) IS NULL)
)
SELECT COUNT(*) FILTER(WHERE path[cardinality(path)] = 'end' AND NOT repeat) AS part1_answer,
    COUNT(*) FILTER(WHERE path[cardinality(path)] = 'end') AS part2_answer
FROM paths;