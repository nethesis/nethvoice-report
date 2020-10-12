DROP TABLE IF EXISTS data_summary_null_year;

DROP TABLE IF EXISTS data_summary_null_month;

DROP TABLE IF EXISTS data_summary_null_week;

DROP TABLE IF EXISTS data_summary_null_day;

CREATE TABLE data_summary_null_year AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y") AS period,
       qname,
       Count(DISTINCT cid) AS uniqCid,
       Count(id) AS num,
       qdescr
FROM
       report_queue
WHERE
       (
              action = 'ABANDON'
              AND hold <= 5
       )
GROUP BY
       period,
       qname
ORDER BY
       period ASC;

CREATE TABLE data_summary_null_month AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y-%m") AS period,
       qname,
       Count(DISTINCT cid) AS uniqCid,
       Count(id) AS num,
       qdescr
FROM
       report_queue
WHERE
       (
              action = 'ABANDON'
              AND hold <= 5
       )
GROUP BY
       period,
       qname
ORDER BY
       period ASC;

CREATE TABLE data_summary_null_week AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y-%u") AS period,
       qname,
       Count(DISTINCT cid) AS uniqCid,
       Count(id) AS num,
       qdescr
FROM
       report_queue
WHERE
       (
              action = 'ABANDON'
              AND hold <= 5
       )
GROUP BY
       period,
       qname
ORDER BY
       period ASC;

CREATE TABLE data_summary_null_day AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS period,
       qname,
       Count(DISTINCT cid) AS uniqCid,
       Count(id) AS num,
       qdescr
FROM
       report_queue
WHERE
       (
              action = 'ABANDON'
              AND hold <= 5
       )
GROUP BY
       period,
       qname
ORDER BY
       period ASC;