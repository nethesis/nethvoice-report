DROP TABLE IF EXISTS performance_failed_year;

DROP TABLE IF EXISTS performance_failed_month;

DROP TABLE IF EXISTS performance_failed_week;

DROP TABLE IF EXISTS performance_failed_day;

CREATE TABLE performance_failed_year AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y") AS period,
    qname,
    Count(id) AS count
FROM
    report_queue
WHERE
    (
        ACTION = 'ABANDON'
        AND hold > 5
    )
GROUP BY
    period,
    qname
ORDER BY
    period ASC;

CREATE TABLE performance_failed_month AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m") AS period,
    qname,
    Count(id) AS count
FROM
    report_queue
WHERE
    (
        ACTION = 'ABANDON'
        AND hold > 5
    )
GROUP BY
    period,
    qname
ORDER BY
    period ASC;

CREATE TABLE performance_failed_week AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%x-W%v") AS period,
    qname,
    Count(id) AS count
FROM
    report_queue
WHERE
    (
        ACTION = 'ABANDON'
        AND hold > 5
    )
GROUP BY
    period,
    qname
ORDER BY
    period ASC;

CREATE TABLE performance_failed_day AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS period,
    qname,
    Count(id) AS count
FROM
    report_queue
WHERE
    (
        ACTION = 'ABANDON'
        AND hold > 5
    )
GROUP BY
    period,
    qname
ORDER BY
    period ASC;