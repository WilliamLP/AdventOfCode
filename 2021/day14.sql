CREATE TEMPORARY TABLE rules AS
SELECT match[1] AS pair, match[2] AS insertion
FROM day14, regexp_match(str, '(\w+)\s->\s(\w)') AS match
WHERE row_id >= 3;

-- Part 1
WITH RECURSIVE insertions(step, str) AS (
    SELECT 0, str FROM day14 WHERE row_id = 1
    UNION ALL
    SELECT step + 1,
        (SELECT string_agg((c1 || COALESCE(rules.insertion, ''))::TEXT, '' ORDER BY i)
        FROM (SELECT i,
                substring(str FROM i FOR 1) AS c1,
                substring(str FROM i+1 FOR 1) AS c2
            FROM generate_series(1, length(str)) AS i) AS pairs
            LEFT JOIN rules ON (rules.pair = (c1 || c2)))
    FROM insertions
    WHERE step < 10
), freq AS (
    SELECT step, ch, count(*) AS count
    FROM insertions, regexp_split_to_table(str, '') AS ch
    GROUP BY 1, 2
)
SELECT max(count) - min(count) AS part1_answer FROM freq WHERE step = 10;

-- Part 2
WITH RECURSIVE pair_transitions AS (
    -- A rule turns a pair into two pairs (or leaves it if there is no rule)
    SELECT pair AS pair_from, substring(pair FROM 1 FOR 1) || insertion AS pair_to FROM rules
    UNION ALL
    SELECT pair AS pair_from, insertion || substring(pair FROM 2) AS pair_to FROM rules
), all_pairs AS (
    SELECT row_number() OVER () AS pair_id, pair, freq FROM (
        SELECT pair, SUM(freq) AS freq FROM (
            SELECT substring(str FROM i FOR 2) AS pair, 1 AS freq
            FROM day14, generate_series(1, length(str)) AS i WHERE row_id = 1
                -- Also we add all possible pairs with 0 frequency so we don't have to add them
            UNION ALL
            SELECT pair_to, 0
            FROM pair_transitions
        ) AS init_pairs
        GROUP BY 1
    ) AS ap
), pair_transition_index AS (
    -- Convert pair transitions to indexes, so we can use matrix-y operations
    SELECT ap_from.pair_id AS from_id, ap_to.pair_id AS to_id
    FROM pair_transitions pt
    JOIN all_pairs ap_from ON (ap_from.pair = pt.pair_from)
    JOIN all_pairs ap_to ON (ap_to.pair = pt.pair_to)
    UNION ALL
    SELECT pair_id, pair_id FROM all_pairs WHERE pair NOT IN (
        SELECT pair_from FROM pair_transitions)
), pair_freqs(step, freqs) AS (
    SELECT 0, array_agg(COALESCE(all_pairs.freq, 0) ORDER BY i)
    FROM generate_series(1, (SELECT MAX(pair_id) FROM all_pairs)) AS i
    LEFT JOIN all_pairs ON (all_pairs.pair_id = i)
    UNION
    SELECT step+1,
        (SELECT array_agg(freq ORDER BY i) FROM (
            SELECT i, sum(COALESCE(freqs[pti.from_id], 0))::BIGINT AS freq
            FROM unnest(freqs) WITH ORDINALITY AS f(freq, i)
            LEFT JOIN pair_transition_index pti ON (pti.to_id = i)
            GROUP BY 1 ORDER BY 1) AS aa
        )
    FROM pair_freqs
    WHERE step < 40
), letter_freq AS (
    SELECT substring(pair FROM 1 FOR 1) AS letter, sum(pf.freqs[ap.pair_id]) AS freq
    FROM all_pairs ap
    LEFT JOIN pair_freqs pf ON (pf.step = 40)
    GROUP BY 1
)
SELECT MAX(freq) - MIN(freq) FROM letter_freq AS part2_answer;

