DROP TABLE IF EXISTS phonebook_map;

CREATE TABLE phonebook_map AS
SELECT DISTINCT
   COALESCE(name, ''),
   COALESCE(company, ''),
   COALESCE(homephone, ''),
   COALESCE(workphone, ''),
   COALESCE(cellphone, '')
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
            GROUP_CONCAT(name)
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
            GROUP_CONCAT(company)
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
    hold AS hold,
    duration AS duration,
    ACTION AS result
FROM
    report_queue
WHERE agent != "NONE"
ORDER BY
    period DESC;
