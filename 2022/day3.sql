WITH items AS (
    SELECT row_num AS sack,
        IF(item between 'a' AND 'z',
            ascii(item) - ascii('a') + 1,
            ascii(item) - ascii('A') + 27) AS priority,
        i < LENGTH(input) / 2 AS in_first_half,
        floor(row_num / 3) AS elf_group
    FROM day3, UNNEST(split(input, '')) AS item WITH OFFSET i
), in_both_halves AS (
    SELECT priority FROM items
    GROUP BY sack, priority HAVING COUNT(DISTINCT in_first_half) = 2
), shared_with_group AS (
    SELECT priority FROM items
    GROUP BY elf_group, priority HAVING COUNT(DISTINCT sack) = 3
)
SELECT (SELECT SUM(priority) FROM in_both_halves) AS part1,
    (SELECT SUM(priority) FROM shared_with_group) AS part2