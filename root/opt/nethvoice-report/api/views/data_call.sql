CREATE TABLE IF NOT EXISTS phonebook_map AS
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
      homephone IS NOT NULL
      OR workphone IS NOT NULL
      OR cellphone IS NOT NULL
   )
ORDER BY
   name;

CREATE TABLE IF NOT EXISTS data_call AS
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
WHERE agent != "NONE"
GROUP BY period, cid, qname
ORDER BY
    period DESC;

ALTER TABLE data_call ADD UNIQUE (period,cid,qname);

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
WHERE agent != "NONE"
      AND Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") = Date_format(NOW(), "%Y-%m-%d")
GROUP BY period, cid, qname
ORDER BY
    period DESC;
