DROP TABLE IF EXISTS graph_agent_aswer_year;

DROP TABLE IF EXISTS graph_agent_aswer_month;

DROP TABLE IF EXISTS graph_agent_aswer_week;

DROP TABLE IF EXISTS graph_agent_aswer_day;

CREATE TABLE graph_agent_aswer_year AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y") AS period,
    qname,
    qdescr,
    IF(
        locate('@', agent) > 0,
        substring_index(substring_index(agent, '/', -2), '@', 1),
        substring_index(substring_index(agent, '/', -1), '-', 1)
    ) AS agent,
    count(id) AS total
FROM
    report_queue
WHERE
    TRUE
    AND ACTION = 'ANSWER'
GROUP BY
    qdescr,
    period,
    agent
ORDER BY
    period,
    qdescr,
    agent;

CREATE TABLE graph_agent_aswer_month AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m") AS period,
    qname,
    qdescr,
    IF(
        locate('@', agent) > 0,
        substring_index(substring_index(agent, '/', -2), '@', 1),
        substring_index(substring_index(agent, '/', -1), '-', 1)
    ) AS agent,
    count(id) AS total
FROM
    report_queue
WHERE
    TRUE
    AND ACTION = 'ANSWER'
GROUP BY
    qdescr,
    period,
    agent
ORDER BY
    period,
    qdescr,
    agent;

CREATE TABLE graph_agent_aswer_week AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%u") AS period,
    qname,
    qdescr,
    IF(
        locate('@', agent) > 0,
        substring_index(substring_index(agent, '/', -2), '@', 1),
        substring_index(substring_index(agent, '/', -1), '-', 1)
    ) AS agent,
    count(id) AS total
FROM
    report_queue
WHERE
    TRUE
    AND ACTION = 'ANSWER'
GROUP BY
    qdescr,
    period,
    agent
ORDER BY
    period,
    qdescr,
    agent;

CREATE TABLE graph_agent_aswer_day AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS period,
    qname,
    qdescr,
    IF(
        locate('@', agent) > 0,
        substring_index(substring_index(agent, '/', -2), '@', 1),
        substring_index(substring_index(agent, '/', -1), '-', 1)
    ) AS agent,
    count(id) AS total
FROM
    report_queue
WHERE
    TRUE
    AND ACTION = 'ANSWER'
GROUP BY
    qdescr,
    period,
    agent
ORDER BY
    period,
    qdescr,
    agent;