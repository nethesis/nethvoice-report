DROP TABLE IF EXISTS data_call;

CREATE TABLE data_call AS
SELECT
    DATE_FORMAT(
        FROM_UNIXTIME(`timestamp_in`),
        '%Y-%m-%d %H:%i:%s'
    ) AS period,
    cid,
    "name from cid" AS name,
    "company from cid" AS company,
    qname,
    qdescr,
    agent,
    position,
    SEC_TO_TIME(hold) AS hold,
    SEC_TO_TIME(duration) AS duration,
    ACTION AS result
FROM
    report_queue
ORDER BY
    period DESC;