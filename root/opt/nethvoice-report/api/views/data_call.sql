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
ORDER BY
    name;

DROP TABLE IF EXISTS data_call;

CREATE TABLE data_call AS
SELECT
    DATE_FORMAT(
        FROM_UNIXTIME(`timestamp_in`),
        '%Y-%m-%d %H:%i:%s'
    ) AS period,
    cid,
    (
        SELECT
            name
        FROM
            phonebook_map
        WHERE
            (
                workphone = report_queue.cid
                OR homephone = report_queue.cid
                OR cellphone = report_queue.cid
            )
            AND report_queue.cid IS NOT NULL
            AND report_queue.cid != ""
    ) AS `name`,
    (
        SELECT
            name
        FROM
            phonebook_map
        WHERE
            (
                workphone = report_queue.cid
                OR homephone = report_queue.cid
                OR cellphone = report_queue.cid
            )
            AND report_queue.cid IS NOT NULL
            AND report_queue.cid != ""
    ) AS `company`,
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