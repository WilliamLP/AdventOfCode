WITH RECURSIVE monkey_input AS (
    SELECT (row_num - 1) / 7 AS monkey_num, string_agg(input, '|') AS input
    FROM day11
    GROUP BY 1
), monkey_parsed AS (
    SELECT monkey_num, input, regexp_match(input,
                                           '^Monkey (\d):\|' ||
                                               '  Starting items: ([^|]+)\|' ||
                                               '  Operation: new = old (.) (\w+)\|' ||
                                               '  Test: divisible by (\d+)\|' ||
                                               '    If true: throw to monkey (\d)\|' ||
                                               '    If false: throw to monkey (\d)') AS match
    FROM monkey_input
), monkey_ops AS (
    SELECT match[1]::INT AS monkey,
        match[3] AS op,
        match[4] AS arg,
        match[5]::INT AS test_divisor,
        match[6]::INT AS true_throw,
        match[7]::INT AS false_throw
    FROM monkey_parsed
), monkey_count AS (
    SELECT COUNT(*) AS monkey_count,
        EXP(SUM(LN(test_divisor)))::BIGINT AS modulus  -- product
    FROM monkey_ops
), monkey_carrying AS (
    SELECT 1 AS next_turn_round,
        0 AS next_turn_monkey,
        match[1]::INT AS monkey,
        regexp_split_to_table(match[2], ', ')::BIGINT AS item
    FROM monkey_parsed
    UNION ALL (
        WITH preprocess AS (
            SELECT next_turn_round, next_turn_monkey, monkey, test_divisor, true_throw, false_throw, monkey_count,
                CASE WHEN next_turn_monkey = monkey THEN
                         (CASE WHEN op = '*' AND arg = 'old' THEN item * item
                               WHEN op = '*' THEN item * arg::INT
                               WHEN op = '+' THEN item + arg::INT END) % modulus
                     ELSE item END AS new_item
            FROM monkey_carrying
            JOIN monkey_ops USING (monkey)
            CROSS JOIN monkey_count
        )
        SELECT CASE WHEN next_turn_monkey + 1 = monkey_count THEN next_turn_round + 1
                    ELSE next_turn_round END AS next_turn_round,
            ((next_turn_monkey + 1) % monkey_count)::INT AS next_turn_monkey,
            -- If it's this monkey's turn, throw the item, otherwise monkey keeps it
            CASE WHEN monkey = next_turn_monkey THEN
                     CASE WHEN new_item % test_divisor = 0 THEN true_throw ELSE false_throw END
                 ELSE monkey END AS monkey,
            new_item
        FROM preprocess
        WHERE next_turn_round <= 10000
    )
), monkey_business AS (
    SELECT next_turn_monkey, COUNT(*) AS processed_count
    FROM monkey_carrying
    WHERE next_turn_monkey = monkey AND next_turn_round <= 10000
    GROUP BY 1
)
SELECT (array_agg(processed_count ORDER BY processed_count DESC))[1] *
    (array_agg(processed_count ORDER BY processed_count DESC))[2] AS part2
FROM monkey_business


