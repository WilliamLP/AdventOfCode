WITH RECURSIVE stripped AS (
    SELECT row_num AS cmd_num, REPLACE(input, '$ ', '') AS input
    FROM day7
), parsed AS (
    SELECT cmd_num, split_part(input, ' ', 1) AS arg1, split_part(input, ' ', 2) AS arg2
    FROM stripped
), cmds AS (
    SELECT 0 AS cmd_num,
        '/' AS path,
        NULL::INT AS file_size
    UNION ALL
    SELECT cmds.cmd_num + 1,
        CASE WHEN arg1 = 'cd' THEN
            CASE WHEN arg2 = '/' THEN '/'
                WHEN arg2 = '..' THEN REGEXP_REPLACE(path, '\w+/$', '')
                ELSE path || arg2 || '/' END
            ELSE path END AS path,
        CASE WHEN arg1 SIMILAR TO '\d+' THEN arg1::INT END AS file_size
    FROM cmds
    JOIN parsed ON (parsed.cmd_num = cmds.cmd_num + 1)
), dirs AS (
    SELECT DISTINCT path FROM cmds
), dir_sizes AS (
    SELECT dirs.path, SUM(file_size) AS dir_size
    FROM dirs JOIN cmds ON STARTS_WITH(cmds.path, dirs.path)
    GROUP BY 1
), part1 AS (
    SELECT SUM(dir_size) AS part1 FROM dir_sizes WHERE dir_size < 100000
), part2 AS (
    SELECT MIN(dir_size) FROM dir_sizes
    WHERE (SELECT dir_size FROM dir_sizes WHERE path = '/') - dir_size <= 40000000
)
SELECT * FROM part1, part2
