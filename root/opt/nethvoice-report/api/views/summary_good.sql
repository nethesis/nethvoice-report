DROP TABLE IF EXISTS summary_good_year;

DROP TABLE IF EXISTS summary_good_month;

DROP TABLE IF EXISTS summary_good_week;

DROP TABLE IF EXISTS summary_good_day;

CREATE TABLE summary_good_year AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y") AS period,
       qname,
       Count(DISTINCT cid) AS uniqCid,
       Count(id) AS num,
       Max(hold) AS max_hold,
       Min(hold) AS min_hold,
       Avg(hold) AS avg_hold,
       Max(duration) AS max_duration,
       Min(duration) AS min_duration,
       Avg(duration) AS avg_duration,
       Max(position) AS max_position,
       Avg(position) AS avg_position,
       qdescr
FROM
       report_queue
WHERE
       action = 'ANSWER'
GROUP BY
       period,
       qname
ORDER BY
       period ASC;

CREATE TABLE summary_good_month AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y-%m") AS period,
       qname,
       Count(DISTINCT cid) AS uniqCid,
       Count(id) AS num,
       Max(hold) AS max_hold,
       Min(hold) AS min_hold,
       Avg(hold) AS avg_hold,
       Max(duration) AS max_duration,
       Min(duration) AS min_duration,
       Avg(duration) AS avg_duration,
       Max(position) AS max_position,
       Avg(position) AS avg_position,
       qdescr
FROM
       report_queue
WHERE
       action = 'ANSWER'
GROUP BY
       period,
       qname
ORDER BY
       period ASC;

CREATE TABLE summary_good_week AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y-%u") AS period,
       qname,
       Count(DISTINCT cid) AS uniqCid,
       Count(id) AS num,
       Max(hold) AS max_hold,
       Min(hold) AS min_hold,
       Avg(hold) AS avg_hold,
       Max(duration) AS max_duration,
       Min(duration) AS min_duration,
       Avg(duration) AS avg_duration,
       Max(position) AS max_position,
       Avg(position) AS avg_position,
       qdescr
FROM
       report_queue
WHERE
       action = 'ANSWER'
GROUP BY
       period,
       qname
ORDER BY
       period ASC;

CREATE TABLE summary_good_day AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS period,
       qname,
       Count(DISTINCT cid) AS uniqCid,
       Count(id) AS num,
       Max(hold) AS max_hold,
       Min(hold) AS min_hold,
       Avg(hold) AS avg_hold,
       Max(duration) AS max_duration,
       Min(duration) AS min_duration,
       Avg(duration) AS avg_duration,
       Max(position) AS max_position,
       Avg(position) AS avg_position,
       qdescr
FROM
       report_queue
WHERE
       action = 'ANSWER'
GROUP BY
       period,
       qname
ORDER BY
       period ASC;