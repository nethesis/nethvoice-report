DROP TABLE IF EXISTS phonebook_map;

CREATE TABLE phonebook_map AS
SELECT
    DISTINCT name,
    company,
    homephone,
    workphone,
    cellphone
FROM
    phonebook.phonebook
WHERE
    (
        name IS NOT NULL
        OR name != ""
    )
    AND (
        homephone IS NOT NULL
        OR homephone != ""
    )
    AND (
        workphone IS NOT NULL
        OR workphone != ""
    )
    AND (
        cellphone IS NOT NULL
        OR cellphone != ""
    )
ORDER BY
    name;

DROP TABLE IF EXISTS data_caller_year;

DROP TABLE IF EXISTS data_caller_month;

DROP TABLE IF EXISTS data_caller_week;

DROP TABLE IF EXISTS data_caller_day;

CREATE TABLE data_caller_year AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y") AS `period`,
    cid,
    qname,
    qdescr,
    count(id) AS `total`,
    SUM(IF(ACTION = 'ANSWER', 1, 0)) AS `good`,
    SUM(
        IF(
            ACTION = 'ABANDON'
            AND hold > 5,
            1,
            0
        )
    ) AS `failed`,
    SUM(IF(ACTION = 'EXITWITHTIMEOUT', 1, 0)) AS `timeout`,
    SUM(IF(ACTION = 'EXITEMPTY', 1, 0)) AS `exitempty`,
    SUM(IF(ACTION = 'EXITWITHKEY', 1, 0)) AS `exitkey`,
    SUM(IF(ACTION = 'FULL', 1, 0)) AS `full`,
    SUM(IF(ACTION IN ('JOINEMPTY', 'JOINUNAVAIL'), 1, 0)) AS `joinempty`,
    SUM(
        IF(
            ACTION = 'ABANDON'
            AND hold <= 5,
            1,
            0
        )
    ) AS `null`,
    Min(hold) AS `min_hold`,
    Avg(hold) AS `avg_hold`,
    Max(hold) AS `max_hold`,
    Min(duration) AS `min_duration`,
    Avg(duration) AS `avg_duration`,
    Max(duration) AS `max_duration`,
    Min(position) AS `min_position`,
    Avg(position) AS `avg_position`,
    Max(position) AS `max_position`
FROM
    report_queue
WHERE
    cid IS NOT NULL
    AND cid != ""
GROUP BY
    cid,
    period,
    qname
ORDER BY
    period,
    cid;

CREATE TABLE data_caller_month AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m") AS `period`,
    cid,
    qname,
    qdescr,
    count(id) AS `total`,
    SUM(IF(ACTION = 'ANSWER', 1, 0)) AS `good`,
    SUM(
        IF(
            ACTION = 'ABANDON'
            AND hold > 5,
            1,
            0
        )
    ) AS `failed`,
    SUM(IF(ACTION = 'EXITWITHTIMEOUT', 1, 0)) AS `timeout`,
    SUM(IF(ACTION = 'EXITEMPTY', 1, 0)) AS `exitempty`,
    SUM(IF(ACTION = 'EXITWITHKEY', 1, 0)) AS `exitkey`,
    SUM(IF(ACTION = 'FULL', 1, 0)) AS `full`,
    SUM(IF(ACTION IN ('JOINEMPTY', 'JOINUNAVAIL'), 1, 0)) AS `joinempty`,
    SUM(
        IF(
            ACTION = 'ABANDON'
            AND hold <= 5,
            1,
            0
        )
    ) AS `null`,
    Min(hold) AS `min_hold`,
    Avg(hold) AS `avg_hold`,
    Max(hold) AS `max_hold`,
    Min(duration) AS `min_duration`,
    Avg(duration) AS `avg_duration`,
    Max(duration) AS `max_duration`,
    Min(position) AS `min_position`,
    Avg(position) AS `avg_position`,
    Max(position) AS `max_position`
FROM
    report_queue
WHERE
    cid IS NOT NULL
    AND cid != ""
GROUP BY
    cid,
    period,
    qname
ORDER BY
    period,
    cid;

CREATE TABLE data_caller_week AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%x-W%v") AS `period`,
    cid,
    qname,
    qdescr,
    count(id) AS `total`,
    SUM(IF(ACTION = 'ANSWER', 1, 0)) AS `good`,
    SUM(
        IF(
            ACTION = 'ABANDON'
            AND hold > 5,
            1,
            0
        )
    ) AS `failed`,
    SUM(IF(ACTION = 'EXITWITHTIMEOUT', 1, 0)) AS `timeout`,
    SUM(IF(ACTION = 'EXITEMPTY', 1, 0)) AS `exitempty`,
    SUM(IF(ACTION = 'EXITWITHKEY', 1, 0)) AS `exitkey`,
    SUM(IF(ACTION = 'FULL', 1, 0)) AS `full`,
    SUM(IF(ACTION IN ('JOINEMPTY', 'JOINUNAVAIL'), 1, 0)) AS `joinempty`,
    SUM(
        IF(
            ACTION = 'ABANDON'
            AND hold <= 5,
            1,
            0
        )
    ) AS `null`,
    Min(hold) AS `min_hold`,
    Avg(hold) AS `avg_hold`,
    Max(hold) AS `max_hold`,
    Min(duration) AS `min_duration`,
    Avg(duration) AS `avg_duration`,
    Max(duration) AS `max_duration`,
    Min(position) AS `min_position`,
    Avg(position) AS `avg_position`,
    Max(position) AS `max_position`
FROM
    report_queue
WHERE
    cid IS NOT NULL
    AND cid != ""
GROUP BY
    cid,
    period,
    qname
ORDER BY
    period,
    cid;

CREATE TABLE data_caller_day AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS `period`,
    cid,
    qname,
    qdescr,
    count(id) AS `total`,
    SUM(IF(ACTION = 'ANSWER', 1, 0)) AS `good`,
    SUM(
        IF(
            ACTION = 'ABANDON'
            AND hold > 5,
            1,
            0
        )
    ) AS `failed`,
    SUM(IF(ACTION = 'EXITWITHTIMEOUT', 1, 0)) AS `timeout`,
    SUM(IF(ACTION = 'EXITEMPTY', 1, 0)) AS `exitempty`,
    SUM(IF(ACTION = 'EXITWITHKEY', 1, 0)) AS `exitkey`,
    SUM(IF(ACTION = 'FULL', 1, 0)) AS `full`,
    SUM(IF(ACTION IN ('JOINEMPTY', 'JOINUNAVAIL'), 1, 0)) AS `joinempty`,
    SUM(
        IF(
            ACTION = 'ABANDON'
            AND hold <= 5,
            1,
            0
        )
    ) AS `null`,
    Min(hold) AS `min_hold`,
    Avg(hold) AS `avg_hold`,
    Max(hold) AS `max_hold`,
    Min(duration) AS `min_duration`,
    Avg(duration) AS `avg_duration`,
    Max(duration) AS `max_duration`,
    Min(position) AS `min_position`,
    Avg(position) AS `avg_position`,
    Max(position) AS `max_position`
FROM
    report_queue
WHERE
    cid IS NOT NULL
    AND cid != ""
GROUP BY
    cid,
    period,
    qname
ORDER BY
    period,
    cid;

DROP TABLE IF EXISTS data_caller_year_name_company;

DROP TABLE IF EXISTS data_caller_month_name_company;

DROP TABLE IF EXISTS data_caller_week_name_company;

DROP TABLE IF EXISTS data_caller_day_name_company;

CREATE TABLE data_caller_year_name_company AS
SELECT
    *,
    (
        SELECT
            GROUP_CONCAT(name)
        FROM
            phonebook_map
        WHERE
            (
                workphone = data_caller_year.cid
                OR homephone = data_caller_year.cid
                OR cellphone = data_caller_year.cid
            )
            AND data_caller_year.cid IS NOT NULL
            AND data_caller_year.cid != ""
    ) AS `name`,
    (
        SELECT
            GROUP_CONCAT(company)
        FROM
            phonebook_map
        WHERE
            (
                workphone = data_caller_year.cid
                OR homephone = data_caller_year.cid
                OR cellphone = data_caller_year.cid
            )
            AND data_caller_year.cid IS NOT NULL
            AND data_caller_year.cid != ""
    ) AS `company`
FROM
    data_caller_year;

CREATE TABLE data_caller_month_name_company AS
SELECT
    *,
    (
        SELECT
            GROUP_CONCAT(name)
        FROM
            phonebook_map
        WHERE
            (
                workphone = data_caller_month.cid
                OR homephone = data_caller_month.cid
                OR cellphone = data_caller_month.cid
            )
            AND data_caller_month.cid IS NOT NULL
            AND data_caller_month.cid != ""
    ) AS `name`,
    (
        SELECT
            GROUP_CONCAT(company)
        FROM
            phonebook_map
        WHERE
            (
                workphone = data_caller_month.cid
                OR homephone = data_caller_month.cid
                OR cellphone = data_caller_month.cid
            )
            AND data_caller_month.cid IS NOT NULL
            AND data_caller_month.cid != ""
    ) AS `company`
FROM
    data_caller_month;

CREATE TABLE data_caller_week_name_company AS
SELECT
    *,
    (
        SELECT
            GROUP_CONCAT(name)
        FROM
            phonebook_map
        WHERE
            (
                workphone = data_caller_week.cid
                OR homephone = data_caller_week.cid
                OR cellphone = data_caller_week.cid
            )
            AND data_caller_week.cid IS NOT NULL
            AND data_caller_week.cid != ""
    ) AS `name`,
    (
        SELECT
            GROUP_CONCAT(company)
        FROM
            phonebook_map
        WHERE
            (
                workphone = data_caller_week.cid
                OR homephone = data_caller_week.cid
                OR cellphone = data_caller_week.cid
            )
            AND data_caller_week.cid IS NOT NULL
            AND data_caller_week.cid != ""
    ) AS `company`
FROM
    data_caller_week;

CREATE TABLE data_caller_day_name_company AS
SELECT
    *,
    (
        SELECT
            GROUP_CONCAT(name)
        FROM
            phonebook_map
        WHERE
            (
                workphone = data_caller_day.cid
                OR homephone = data_caller_day.cid
                OR cellphone = data_caller_day.cid
            )
            AND data_caller_day.cid IS NOT NULL
            AND data_caller_day.cid != ""
    ) AS `name`,
    (
        SELECT
            GROUP_CONCAT(company)
        FROM
            phonebook_map
        WHERE
            (
                workphone = data_caller_day.cid
                OR homephone = data_caller_day.cid
                OR cellphone = data_caller_day.cid
            )
            AND data_caller_day.cid IS NOT NULL
            AND data_caller_day.cid != ""
    ) AS `company`
FROM
    data_caller_day;