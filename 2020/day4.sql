/*
byr (Birth Year)
iyr (Issue Year)
eyr (Expiration Year)
hgt (Height)
hcl (Hair Color)
ecl (Eye Color)
pid (Passport ID)
cid (Country ID) - OPTIONAL
 */

-- Part 1
WITH count_blanks AS (
    SELECT id, str,
        SUM((str = '')::INT) OVER (ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS grp_num
    FROM day4
), grouped AS (
    SELECT grp_num, string_agg(str, ' ') AS str
    FROM count_blanks
    WHERE str != ''
    GROUP BY grp_num
    ORDER BY grp_num
), keyvals AS (
    SELECT grp_num,
        string_to_table(str, ' ') as keyval
    FROM grouped
), keys AS (
    SELECT DISTINCT grp_num, split_part(keyval, ':', 1) AS key
    FROM keyvals
), counts AS (
    SELECT grp_num, SUM((key IN ('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'))::INT) AS key_count
    FROM keys
    GROUP BY 1
)
SELECT COUNT(*) FROM counts WHERE key_count = 7;
