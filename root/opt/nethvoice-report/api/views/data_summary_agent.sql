DROP TABLE IF EXISTS data_summary_agent_year;

DROP TABLE IF EXISTS data_summary_agent_month;

DROP TABLE IF EXISTS data_summary_agent_week;

DROP TABLE IF EXISTS data_summary_agent_day;

CREATE TABLE data_summary_agent_year AS
SELECT
       Date_format(calldate, "%Y") AS period,
       cnum AS agentNum,
       (
              SELECT
                     name
              FROM
                     agent_extensions
              WHERE
                     extension = asteriskcdrdb.cdr.cnum
       ) AS agentName,
       Count(*) AS total,
       Count(DISTINCT clid) AS uniqCid,
       Min(billsec) AS minBill,
       Avg(billsec) AS avgBill,
       Max(billsec) AS maxBill
FROM
       asteriskcdrdb.cdr
WHERE
       billsec != 0
       AND cnum IN (
              SELECT
                     extension
              FROM
                     agent_extensions
       )
GROUP BY
       period,
       cnum;

CREATE TABLE data_summary_agent_month AS
SELECT
       Date_format(calldate, "%Y-%m") AS period,
       cnum AS agentNum,
       (
              SELECT
                     name
              FROM
                     agent_extensions
              WHERE
                     extension = asteriskcdrdb.cdr.cnum
       ) AS agentName,
       Count(*) AS total,
       Count(DISTINCT clid) AS uniqCid,
       Min(billsec) AS minBill,
       Avg(billsec) AS avgBill,
       Max(billsec) AS maxBill
FROM
       asteriskcdrdb.cdr
WHERE
       billsec != 0
       AND cnum IN (
              SELECT
                     extension
              FROM
                     agent_extensions
       )
GROUP BY
       period,
       cnum;

CREATE TABLE data_summary_agent_week AS
SELECT
       Date_format(calldate, "%x-W%v") AS period,
       cnum AS agentNum,
       (
              SELECT
                     name
              FROM
                     agent_extensions
              WHERE
                     extension = asteriskcdrdb.cdr.cnum
       ) AS agentName,
       Count(*) AS total,
       Count(DISTINCT clid) AS uniqCid,
       Min(billsec) AS minBill,
       Avg(billsec) AS avgBill,
       Max(billsec) AS maxBill
FROM
       asteriskcdrdb.cdr
WHERE
       billsec != 0
       AND cnum IN (
              SELECT
                     extension
              FROM
                     agent_extensions
       )
GROUP BY
       period,
       cnum;

CREATE TABLE data_summary_agent_day AS
SELECT
       Date_format(calldate, "%Y-%m-%d") AS period,
       cnum AS agentNum,
       (
              SELECT
                     name
              FROM
                     agent_extensions
              WHERE
                     extension = asteriskcdrdb.cdr.cnum
       ) AS agentName,
       Count(*) AS total,
       Count(DISTINCT clid) AS uniqCid,
       Min(billsec) AS minBill,
       Avg(billsec) AS avgBill,
       Max(billsec) AS maxBill
FROM
       asteriskcdrdb.cdr
WHERE
       billsec != 0
       AND cnum IN (
              SELECT
                     extension
              FROM
                     agent_extensions
       )
GROUP BY
       period,
       cnum;