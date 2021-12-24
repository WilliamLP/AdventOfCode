CREATE TEMPORARY TABLE cubes AS
    SELECT row_id cube_id, parsed[1] = 'on' state,
        parsed[2]::BIGINT x1, parsed[3]::BIGINT x2,
        parsed[4]::BIGINT y1, parsed[5]::BIGINT y2,
        parsed[6]::BIGINT z1, parsed[7]::BIGINT z2
    FROM day22_test2, regexp_match(str,
        '(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)') parsed;

WITH xs AS (
    SELECT x1 x, LEAD(x1) OVER (ORDER BY x1) x2 FROM (
        SELECT DISTINCT x1 FROM cubes UNION SELECT x2 + 1 FROM cubes
    ) _
), ys AS (
    SELECT y1 y, LEAD(y1) OVER (ORDER BY y1) y2 FROM (
        SELECT DISTINCT y1 FROM cubes UNION SELECT y2 + 1 FROM cubes
    ) _
), zs AS (
    SELECT z1 z, LEAD(z1) OVER (ORDER BY z1) z2 FROM (
        SELECT DISTINCT z1 FROM cubes UNION SELECT z2 + 1 FROM cubes
    ) _
), active_cubes AS (
    SELECT DISTINCT ON (x, y, z)
        x, y, z, cube_id, state, (xs.x2 - x) * (ys.y2 - y) * (zs.z2 - z) volume
    FROM xs, ys, zs, cubes
    WHERE x BETWEEN cubes.x1 AND cubes.x2
        AND y BETWEEN cubes.y1 AND cubes.y2
        AND z BETWEEN cubes.z1 AND cubes.z2
    ORDER BY x, y, z, cube_id DESC
)
SELECT sum(volume) AS part_2_answer FROM active_cubes WHERE state;