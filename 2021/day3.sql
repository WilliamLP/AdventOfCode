DROP TABLE IF EXISTS day3_length;
CREATE TABLE day3_length AS
SELECT char_length(str) AS length FROM day3 LIMIT 1;

-- Part 1
WITH bits AS (
    SELECT id, i, substring(str FROM i FOR 1)
    FROM day3, day3_length, generate_series(1,length) AS i
), bitwise_avg AS (
    SELECT i, round(avg(substring::INT)) as most_common
    FROM bits
    GROUP BY i
), epsilon AS (
    SELECT sum(2^(length - i))::INT AS epsilon
    FROM bitwise_avg, day3_length
    WHERE most_common = 1
), gamma AS (
    SELECT (2^length)::INT - 1 - epsilon AS gamma
    FROM epsilon, day3_length
)
SELECT epsilon, gamma, epsilon * gamma AS part_1_answer
FROM epsilon, gamma;

-- Part 2
WITH RECURSIVE array_reduction(next_pos, oxygen, scrubber) AS (
    SELECT 1,
        array_agg(str),
        array_agg(str)
    FROM day3
    UNION ALL
    SELECT next_pos+1,
        (SELECT array_agg(elem) FROM (
            SELECT elem
            FROM unnest(oxygen) AS elem
            WHERE substring(elem FROM next_pos FOR 1) = (
                SELECT round(avg(
                    substring(elem2 FROM next_pos FOR 1)::INT))::CHAR
                FROM unnest(oxygen) AS elem2
            )
        ) AS filtered),
        (SELECT array_agg(elem) FROM (
            SELECT elem
            FROM unnest(scrubber) AS elem
            WHERE substring(elem FROM next_pos FOR 1) != (
                SELECT round(avg(
                        substring(elem2 FROM next_pos FOR 1)::INT))::CHAR
                FROM unnest(scrubber) AS elem2
            ) OR 1 = (
                SELECT COUNT(DISTINCT substring(elem2 FROM next_pos FOR 1))
                FROM unnest(scrubber) AS elem2
            )
        ) AS filtered)
    FROM array_reduction
    WHERE next_pos <= 12
), to_decimal AS (
    SELECT oxygen[1]::BIT(12)::INT AS oxygen,
        scrubber[1]::BIT(12)::INT AS scrubber
    FROM array_reduction, day3_length
    WHERE next_pos = length + 1
)
SELECT oxygen, scrubber, oxygen * scrubber AS part2_answer
FROM to_decimal;