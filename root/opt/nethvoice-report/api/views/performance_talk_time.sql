DROP TABLE IF EXISTS performance_talk_time_total;

DROP TABLE IF EXISTS performance_talk_time_total_5;

DROP TABLE IF EXISTS performance_talk_time_total_10;

DROP TABLE IF EXISTS performance_talk_time_total_15;

DROP TABLE IF EXISTS performance_talk_time_total_20;

DROP TABLE IF EXISTS performance_talk_time_total_25;

DROP TABLE IF EXISTS performance_talk_time_total_30;

DROP TABLE IF EXISTS performance_talk_time_total_45;

DROP TABLE IF EXISTS performance_talk_time_total_60;

DROP TABLE IF EXISTS performance_talk_time_total_75;

DROP TABLE IF EXISTS performance_talk_time_total_90;

DROP TABLE IF EXISTS performance_talk_time_total_105;

DROP TABLE IF EXISTS performance_talk_time_total_120;

DROP TABLE IF EXISTS performance_talk_time_total_180;

DROP TABLE IF EXISTS performance_talk_time_total_240;

DROP TABLE IF EXISTS performance_talk_time_total_300;

DROP TABLE IF EXISTS performance_talk_time_total_450;

DROP TABLE IF EXISTS performance_talk_time_total_600;

DROP TABLE IF EXISTS performance_talk_time_total_600p;

CREATE TABLE performance_talk_time_total AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_5 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 5
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_10 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 10
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_15 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 15
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_20 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 20
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_25 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 25
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_30 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 30
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_45 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 45
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_60 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 60
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_75 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 75
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_90 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 90
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_105 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 105
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_120 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 120
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_180 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 180
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_240 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 240
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_300 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 300
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_450 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 450
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_600 AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 0
       AND asteriskcdrdb.cdr.billsec <= 600
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;

CREATE TABLE performance_talk_time_total_600p AS
SELECT
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS timestamp_in,
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d') AS timestamp_out,
       qname,
       Count(*) AS count
FROM
       asteriskcdrdb.report_queue
       JOIN asteriskcdrdb.cdr ON asteriskcdrdb.cdr.uniqueid = asteriskcdrdb.report_queue.timestamp_in
WHERE
       asteriskcdrdb.report_queue.action = 'ANSWER'
       AND asteriskcdrdb.cdr.disposition = 'ANSWERED'
       AND asteriskcdrdb.cdr.billsec > 600
GROUP BY
       Date_format(From_unixtime(timestamp_in), '%Y-%m-%d'),
       Date_format(From_unixtime(timestamp_out), '%Y-%m-%d'),
       qname;
