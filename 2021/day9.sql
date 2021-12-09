CREATE TEMPORARY TABLE parsed AS (
    SELECT row_number() over () AS id, x, id AS y, n::int
    FROM day9, unnest(regexp_split_to_array(str, '')) WITH ORDINALITY AS coord(n, x)
);
CREATE INDEX ON parsed(x, y);
CREATE INDEX ON parsed(y, x);

CREATE TEMPORARY TABLE coords AS
SELECT c1.id, c1.x, c1.y, c1.n, array_agg(c2.id) AS adjacent, NULL::INT AS basin
FROM parsed c1
JOIN parsed c2 ON (
    (c2.x = c1.x AND (c2.y = c1.y - 1 OR c2.y = c1.y + 1)) OR
    (c2.y = c1.y AND (c2.x = c1.x - 1 OR c2.x = c1.x +1)))
GROUP BY 1,2,3,4;

WITH low_points AS (
    SELECT c1.id
    FROM coords c1, unnest(c1.adjacent) AS adjacent_id
                    JOIN coords c2 ON (c2.id = adjacent_id)
    GROUP BY 1
    HAVING MIN(c2.n - c1.n) > 0
)
UPDATE coords c
SET basin = lp.id
FROM low_points lp WHERE lp.id = c.id;

SELECT sum(n+1) AS part1_answer FROM coords WHERE basin IS NOT NULL;

-- 8x copy pasta!
WITH captured AS (
    SELECT c1.id, c2.basin FROM coords c1 CROSS JOIN unnest(c1.adjacent) AS adj_id
    JOIN coords c2 ON (c2.id = adj_id AND c2.n < c1.n AND c2.basin IS NOT NULL)
    WHERE c1.basin IS NULL AND c1.n < 9
)
UPDATE coords c SET basin = cp.basin FROM captured cp WHERE c.id = cp.id;

WITH captured AS (
    SELECT c1.id, c2.basin FROM coords c1 CROSS JOIN unnest(c1.adjacent) AS adj_id
    JOIN coords c2 ON (c2.id = adj_id AND c2.n < c1.n AND c2.basin IS NOT NULL)
    WHERE c1.basin IS NULL AND c1.n < 9
)
UPDATE coords c SET basin = cp.basin FROM captured cp WHERE c.id = cp.id;

WITH captured AS (
    SELECT c1.id, c2.basin FROM coords c1 CROSS JOIN unnest(c1.adjacent) AS adj_id
    JOIN coords c2 ON (c2.id = adj_id AND c2.n < c1.n AND c2.basin IS NOT NULL)
    WHERE c1.basin IS NULL AND c1.n < 9
)
UPDATE coords c SET basin = cp.basin FROM captured cp WHERE c.id = cp.id;

WITH captured AS (
    SELECT c1.id, c2.basin FROM coords c1 CROSS JOIN unnest(c1.adjacent) AS adj_id
    JOIN coords c2 ON (c2.id = adj_id AND c2.n < c1.n AND c2.basin IS NOT NULL)
    WHERE c1.basin IS NULL AND c1.n < 9
)
UPDATE coords c SET basin = cp.basin FROM captured cp WHERE c.id = cp.id;

WITH captured AS (
    SELECT c1.id, c2.basin FROM coords c1 CROSS JOIN unnest(c1.adjacent) AS adj_id
    JOIN coords c2 ON (c2.id = adj_id AND c2.n < c1.n AND c2.basin IS NOT NULL)
    WHERE c1.basin IS NULL AND c1.n < 9
)
UPDATE coords c SET basin = cp.basin FROM captured cp WHERE c.id = cp.id;

WITH captured AS (
    SELECT c1.id, c2.basin FROM coords c1 CROSS JOIN unnest(c1.adjacent) AS adj_id
    JOIN coords c2 ON (c2.id = adj_id AND c2.n < c1.n AND c2.basin IS NOT NULL)
    WHERE c1.basin IS NULL AND c1.n < 9
)
UPDATE coords c SET basin = cp.basin FROM captured cp WHERE c.id = cp.id;

WITH captured AS (
    SELECT c1.id, c2.basin FROM coords c1 CROSS JOIN unnest(c1.adjacent) AS adj_id
    JOIN coords c2 ON (c2.id = adj_id AND c2.n < c1.n AND c2.basin IS NOT NULL)
    WHERE c1.basin IS NULL AND c1.n < 9
)
UPDATE coords c SET basin = cp.basin FROM captured cp WHERE c.id = cp.id;

WITH captured AS (
    SELECT c1.id, c2.basin FROM coords c1 CROSS JOIN unnest(c1.adjacent) AS adj_id
    JOIN coords c2 ON (c2.id = adj_id AND c2.n < c1.n AND c2.basin IS NOT NULL)
    WHERE c1.basin IS NULL AND c1.n < 9
)
UPDATE coords c SET basin = cp.basin FROM captured cp WHERE c.id = cp.id;

WITH basins AS (
    SELECT basin, COUNT(*) AS count FROM coords WHERE basin IS NOT NULL
    GROUP BY basin ORDER BY count DESC LIMIT 3
)
SELECT round(exp(SUM(ln(count)))) AS part2_answer FROM basins; -- no "product" aggregate in psql

