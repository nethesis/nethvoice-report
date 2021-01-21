DROP TABLE IF EXISTS phonebook_map;
CREATE TABLE phonebook_map AS
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
      (homephone IS NOT NULL
      AND homephone != ""
      AND homephone REGEXP ('^[0-9]+$'))
      OR (workphone IS NOT NULL
      AND workphone != ""
      AND workphone REGEXP ('^[0-9]+$'))
      OR (cellphone IS NOT NULL
      AND cellphone != ""
      AND cellphone REGEXP ('^[0-9]+$'))
   )
ORDER BY
   name;

CREATE TABLE IF NOT EXISTS data_call
(UNIQUE KEY `period` (`period`,`cid`,`qname`))
SELECT
    DATE_FORMAT(
        FROM_UNIXTIME(`timestamp_in`),
        '%Y-%m-%d %H:%i:%s'
    ) AS period,
    cid,
    qname,
    qdescr,
    agent,
    position,
    hold AS hold,
    duration AS duration,
    ACTION AS result
FROM
    report_queue
GROUP BY period, cid, qname
ORDER BY
    period;

INSERT IGNORE INTO data_call
SELECT
    DATE_FORMAT(
        FROM_UNIXTIME(`timestamp_in`),
        '%Y-%m-%d %H:%i:%s'
    ) AS period,
    cid,
    qname,
    qdescr,
    agent,
    position,
    hold AS hold,
    duration AS duration,
    ACTION AS result
FROM
    report_queue
WHERE Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") = Date_format(NOW() - INTERVAL 1 DAY, "%Y-%m-%d")
GROUP BY period, cid, qname
ORDER BY
    period;
