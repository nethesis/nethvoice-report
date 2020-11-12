CREATE TABLE IF NOT EXISTS phonebook_map AS
SELECT DISTINCT
   COALESCE(name, '') AS name,
   COALESCE(company, '') AS company,
   COALESCE(homephone, '') AS homephone,
   COALESCE(workphone, '') AS workphone,
   COALESCE(cellphone, '') AS cellphone
FROM
   phonebook.phonebook
WHERE
   (
      name IS NOT NULL
      OR name != ""
      OR company IS NOT NULL
      OR company != ""
   )
   AND
   (
      homephone IS NOT NULL
      OR workphone IS NOT NULL
      OR cellphone IS NOT NULL
   )
ORDER BY
   name;

DROP TABLE IF EXISTS data_caller_year;

DROP TABLE IF EXISTS data_caller_month;

DROP TABLE IF EXISTS data_caller_week;

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

CREATE TABLE IF NOT EXISTS data_caller_day AS
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

ALTER TABLE data_caller_day ADD UNIQUE (period,cid,qname);

INSERT IGNORE INTO data_caller_day
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
    AND Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") = Date_format(NOW(), "%Y-%m-%d")
GROUP BY
    cid,
    period,
    qname
ORDER BY
    period,
    cid;
