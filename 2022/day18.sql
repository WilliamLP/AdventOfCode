WITH cubes AS (
    SELECT split_part(input, ',', 1)::int as x,
        split_part(input, ',', 2)::int as y,
        split_part(input, ',', 3)::int as z
    FROM day18
), free_sides AS (
    SELECT COALESCE(z - LAG(z) OVER xy, 0) != 1 AS z1,
        COALESCE(LEAD(z) OVER xy - z, 0) != 1 AS z2,
        COALESCE(y - LAG(y) OVER xz, 0) != 1 AS y1,
        COALESCE(LEAD(y) OVER xz - y, 0) != 1 AS y2,
        COALESCE(x - LAG(x) OVER yz, 0) != 1 AS x1,
        COALESCE(LEAD(x) OVER yz - x, 0) != 1 AS x2
    FROM cubes
    WINDOW xy AS (PARTITION BY x, y ORDER BY z),
        xz AS (PARTITION BY x, z ORDER BY y),
        yz AS (PARTITION BY y, z ORDER BY x)
), part1 AS (
    SELECT SUM(z1::INT) + SUM(z2::INT) +
        SUM(y1::INT) + SUM(y2::INT) +
        SUM(x1::INT) + SUM(x2::INT) AS part1
    FROM free_sides
)
select * from part1;
