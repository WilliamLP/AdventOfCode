CREATE TEMPORARY TABLE nums AS
SELECT id AS row_id, num_str, pos
FROM day8, unnest(regexp_split_to_array(str, '[ |]+')) WITH ORDINALITY AS num(num_str, pos);

SELECT COUNT(*) AS part1_answer FROM nums WHERE length(num_str) IN (2, 3, 4, 7) AND pos > 10;

CREATE TEMPORARY TABLE nums_bits AS (
    SELECT row_id, pos, length(num_str) AS length,
        SUM(((num_str ~ chr(97 + i))::INT) << i)::BIT(7) AS bits
    FROM nums, generate_series(0, 6) AS i
    GROUP BY 1,2,3
);

CREATE TEMPORARY TABLE bit_count AS
SELECT n::BIT(7), length(replace(n::BIT(7)::TEXT, '0', '')) AS bit_count
FROM generate_series(0,127) AS n;

CREATE TEMPORARY TABLE decoder(row_id INT, bits BIT(7), n INT);

INSERT INTO decoder
SELECT row_id, bits, 1 FROM nums_bits WHERE length = 2 AND pos <= 10;

INSERT INTO decoder
SELECT row_id, bits, 4 FROM nums_bits WHERE length = 4 AND pos <= 10;

INSERT INTO decoder
SELECT row_id, bits, 7 FROM nums_bits WHERE length = 3 AND pos <= 10;

INSERT INTO decoder
SELECT row_id, bits, 8 FROM nums_bits WHERE length = 7 AND pos <= 10;

-- 3: length 5 and contains 1
INSERT INTO decoder
SELECT n.row_id, n.bits, 3
FROM nums_bits n
JOIN decoder n1 ON (n1.row_id = n.row_id AND n1.n = 1)
WHERE n.length = 5 AND n.pos <= 10 AND (n1.bits & n.bits) = n1.bits;

-- 2: length 5, 2 segments overlap with 4
INSERT INTO decoder
SELECT n.row_id, n.bits, 2
FROM nums_bits n
JOIN decoder n4 ON (n4.row_id = n.row_id AND n4.n = 4)
JOIN bit_count bc ON (bc.n = (n4.bits & n.bits))
WHERE n.length = 5 AND n.pos <= 10 AND bc.bit_count = 2;

-- 5: length 5, not 2 or 3
INSERT INTO decoder
SELECT n.row_id, n.bits, 5
FROM nums_bits n
LEFT JOIN decoder nd ON (nd.row_id = n.row_id AND nd.bits = n.bits)
WHERE n.length = 5 AND n.pos <= 10 AND nd.row_id IS NULL;

-- 6: length 6, does not contain 1
INSERT INTO decoder
SELECT n.row_id, n.bits, 6
FROM nums_bits n
JOIN decoder n1 ON (n1.row_id = n.row_id AND n1.n = 1)
WHERE n.length = 6 AND n.pos <= 10 AND (n1.bits & n.bits) != n1.bits;

-- 9: length 6, contains 4
INSERT INTO decoder
SELECT n.row_id, n.bits, 9
FROM nums_bits n
JOIN decoder n4 ON (n4.row_id = n.row_id AND n4.n = 4)
WHERE n.length = 6 AND n.pos <= 10 AND (n4.bits & n.bits) = n4.bits;

-- 0: length 6, not 6 or 9
INSERT INTO decoder
SELECT n.row_id, n.bits, 0
FROM nums_bits n
LEFT JOIN decoder nd ON (nd.row_id = n.row_id AND nd.bits = n.bits)
WHERE n.length = 6 AND n.pos <= 10 AND nd.row_id IS NULL;

WITH decoded AS (
    SELECT n.row_id, d.n * 10 ^ (14-pos) AS n
    FROM nums_bits n
    JOIN decoder d ON (d.row_id = n.row_id AND d.bits = n.bits)
    WHERE n.pos >= 11
)
SELECT SUM(n) FROM decoded AS part2_answer;
