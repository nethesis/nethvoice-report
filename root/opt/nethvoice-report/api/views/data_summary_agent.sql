DROP TABLE IF EXISTS data_summary_agent_year;

DROP TABLE IF EXISTS data_summary_agent_month;

DROP TABLE IF EXISTS data_summary_agent_week;

DROP TABLE IF EXISTS data_summary_agent_day;

CREATE TABLE data_summary_agent_year AS
SELECT
       Date_format(calldate, "%Y") AS period,
       IF(cnum IS NULL OR cnum = "", src, cnum) AS agentNum,
       (
              SELECT
                     name
              FROM
                     agent_extensions
              WHERE
                     extension = IF(asteriskcdrdb.cdr.cnum IS NULL OR asteriskcdrdb.cdr.cnum = "", asteriskcdrdb.cdr.src, asteriskcdrdb.cdr.cnum)
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
       AND IF(cnum IS NULL OR cnum = "", src, cnum) IN (
              SELECT
                     extension
              FROM
                     agent_extensions
       )
GROUP BY
       period,
       IF(cnum IS NULL OR cnum = "", src, cnum);

CREATE TABLE data_summary_agent_month AS
SELECT
       Date_format(calldate, "%Y-%m") AS period,
       IF(cnum IS NULL OR cnum = "", src, cnum) AS agentNum,
       (
              SELECT
                     name
              FROM
                     agent_extensions
              WHERE
                     extension = IF(asteriskcdrdb.cdr.cnum IS NULL OR asteriskcdrdb.cdr.cnum = "", asteriskcdrdb.cdr.src, asteriskcdrdb.cdr.cnum)
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
       AND IF(cnum IS NULL OR cnum = "", src, cnum) IN (
              SELECT
                     extension
              FROM
                     agent_extensions
       )
GROUP BY
       period,
       IF(cnum IS NULL OR cnum = "", src, cnum);

CREATE TABLE data_summary_agent_week AS
SELECT
       Date_format(calldate, "%x-W%v") AS period,
       IF(cnum IS NULL OR cnum = "", src, cnum) AS agentNum,
       (
              SELECT
                     name
              FROM
                     agent_extensions
              WHERE
                     extension = IF(asteriskcdrdb.cdr.cnum IS NULL OR asteriskcdrdb.cdr.cnum = "", asteriskcdrdb.cdr.src, asteriskcdrdb.cdr.cnum)
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
       AND IF(cnum IS NULL OR cnum = "", src, cnum) IN (
              SELECT
                     extension
              FROM
                     agent_extensions
       )
GROUP BY
       period,
       IF(cnum IS NULL OR cnum = "", src, cnum);

CREATE TABLE data_summary_agent_day AS
SELECT
       Date_format(calldate, "%Y-%m-%d") AS period,
       IF(cnum IS NULL OR cnum = "", src, cnum) AS agentNum,
       (
              SELECT
                     name
              FROM
                     agent_extensions
              WHERE
                     extension = IF(asteriskcdrdb.cdr.cnum IS NULL OR asteriskcdrdb.cdr.cnum = "", asteriskcdrdb.cdr.src, asteriskcdrdb.cdr.cnum)
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
       AND IF(cnum IS NULL OR cnum = "", src, cnum) IN (
              SELECT
                     extension
              FROM
                     agent_extensions
       )
GROUP BY
       period,
       IF(cnum IS NULL OR cnum = "", src, cnum);