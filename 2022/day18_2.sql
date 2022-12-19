WITH RECURSIVE cubes AS (
    SELECT split_part(input, ',', 1)::int as x,
        split_part(input, ',', 2)::int as y,
        split_part(input, ',', 3)::int as z
    FROM day18
), dims AS (
    SELECT MIN(x)-1 AS min_x, MIN(y)-1 AS min_y, MIN(z)-1 AS min_z,
        MAX(x)+1 AS max_x, MAX(y)+1 AS max_y, MAX(z)+1 AS max_z
    FROM cubes
), dirs AS (
    SELECT -1 AS dx, 0 AS dy, 0 AS dz UNION ALL SELECT 1, 0, 0
    UNION ALL SELECT 0, -1, 0 UNION ALL SELECT 0, 1, 0
    UNION ALL SELECT 0, 0, -1 UNION ALL SELECT 0, 0, 1
), flood AS (
    SELECT min_x AS x, min_y AS y, min_z AS z
    FROM dims
    UNION
    SELECT flood.x + dx, flood.y + dy, flood.z + dz
    FROM flood
    CROSS JOIN dims
    CROSS JOIN dirs
    LEFT JOIN cubes ON (cubes.x = flood.x + dx
        AND cubes.y = flood.y + dy
        AND cubes.z = flood.z + dz)
    WHERE flood.x + dx BETWEEN min_x AND max_x
        AND flood.y + dy BETWEEN min_y AND max_y
        AND flood.z + dz BETWEEN min_z AND max_z
        AND cubes.x IS NULL
)
SElECT COUNT(*) AS part_2
FROM cubes, dirs, flood
WHERE cubes.x + dx = flood.x AND cubes.y + dy = flood.y AND cubes.z + dz = flood.z