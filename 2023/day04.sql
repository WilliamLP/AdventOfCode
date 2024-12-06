WITH RECURSIVE parsed AS (
    SELECT row_num AS card_id, regexp_matches(trim(input), '^(.+): (.+) \| (.+)$') AS arr
    FROM day04
), winning AS (
    SELECT card_id, val::INT
    FROM parsed, regexp_split_to_table(trim(arr[2]), '\s+') AS val
), on_card AS (
    SELECT card_id, val::INT
    FROM parsed, regexp_split_to_table(trim(arr[3]), '\s+') AS val
), wins_on_card AS (
    SELECT oc.card_id, COUNT(*) AS count
    FROM on_card oc
    JOIN winning w ON (w.card_id = oc.card_id AND w.val = oc.val)
    GROUP BY 1
), card_counts (last_card_id, count_arr) AS (
    SELECT 1, (SELECT array_agg(1) FROM parsed)
    UNION ALL
    SELECT
        last_card_id + 1, (
            SELECT array_agg(card_count + COALESCE((
                SELECT CASE
                    WHEN arr.card_id != last_card_id + 1 THEN 0
                    ELSE SUM(count_arr[i])::INT
                END
                FROM generate_series(1, last_card_id) AS series(i)
                JOIN wins_on_card wc ON(
                    wc.card_id = i AND wc.count >= last_card_id + 1 - i)
            ), 0))
            FROM unnest(count_arr) WITH ORDINALITY AS arr(card_count, card_id)
        )
    FROM card_counts
    WHERE last_card_id < array_length(count_arr, 1)
), part1 AS (
    SELECT SUM(2 ^ (count - 1)) AS part1
    FROM wins_on_card
), part2 AS (
    SELECT SUM(cnt) AS part_2
    FROM card_counts,
        unnest(count_arr) AS arr(cnt)
    WHERE last_card_id = array_length(count_arr, 1)
)
SELECT *
FROM part1, part2;