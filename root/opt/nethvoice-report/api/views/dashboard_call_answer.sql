DROP TABLE IF EXISTS dashboard_call_answer_year;

DROP TABLE IF EXISTS dashboard_call_answer_month;

DROP TABLE IF EXISTS dashboard_call_answer_week;

DROP TABLE IF EXISTS dashboard_call_answer_day;

CREATE TABLE dashboard_call_answer_year AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y") AS period,
    Date_format(
        Sec_to_time(
            Time_to_sec(From_unixtime(timestamp_in)) - Time_to_sec(From_unixtime(timestamp_in)) % (60 * 60) + (60 * 60)
        ),
        "%H:%i"
    ) AS time_60,
    count(*) AS total
FROM
    report_queue_agents
WHERE
    ACTION = "ANSWER"
GROUP BY
    period,
    time_60
ORDER BY
    period,
    time_60;

CREATE TABLE dashboard_call_answer_month AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m") AS period,
    Date_format(
        Sec_to_time(
            Time_to_sec(From_unixtime(timestamp_in)) - Time_to_sec(From_unixtime(timestamp_in)) % (60 * 60) + (60 * 60)
        ),
        "%H:%i"
    ) AS time_60,
    count(*) AS total
FROM
    report_queue_agents
WHERE
    ACTION = "ANSWER"
GROUP BY
    period,
    time_60
ORDER BY
    period,
    time_60;

CREATE TABLE dashboard_call_answer_week AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%u") AS period,
    Date_format(
        Sec_to_time(
            Time_to_sec(From_unixtime(timestamp_in)) - Time_to_sec(From_unixtime(timestamp_in)) % (60 * 60) + (60 * 60)
        ),
        "%H:%i"
    ) AS time_60,
    count(*) AS total
FROM
    report_queue_agents
WHERE
    ACTION = "ANSWER"
GROUP BY
    period,
    time_60
ORDER BY
    period,
    time_60;

CREATE TABLE dashboard_call_answer_day AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS period,
    Date_format(
        Sec_to_time(
            Time_to_sec(From_unixtime(timestamp_in)) - Time_to_sec(From_unixtime(timestamp_in)) % (60 * 60) + (60 * 60)
        ),
        "%H:%i"
    ) AS time_60,
    count(*) AS total
FROM
    report_queue_agents
WHERE
    ACTION = "ANSWER"
GROUP BY
    period,
    time_60
ORDER BY
    period,
    time_60;

DROP TABLE IF EXISTS dashboard_call_noanswer_year;

DROP TABLE IF EXISTS dashboard_call_noanswer_month;

DROP TABLE IF EXISTS dashboard_call_noanswer_week;

DROP TABLE IF EXISTS dashboard_call_noanswer_day;

CREATE TABLE dashboard_call_noanswer_year AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y") AS period,
    Date_format(
        Sec_to_time(
            Time_to_sec(From_unixtime(timestamp_in)) - Time_to_sec(From_unixtime(timestamp_in)) % (60 * 60) + (60 * 60)
        ),
        "%H:%i"
    ) AS time_60,
    count(*) AS total
FROM
    report_queue_agents
WHERE
    ACTION = "RINGNOANSWER"
GROUP BY
    period,
    time_60
ORDER BY
    period,
    time_60;

CREATE TABLE dashboard_call_noanswer_month AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m") AS period,
    Date_format(
        Sec_to_time(
            Time_to_sec(From_unixtime(timestamp_in)) - Time_to_sec(From_unixtime(timestamp_in)) % (60 * 60) + (60 * 60)
        ),
        "%H:%i"
    ) AS time_60,
    count(*) AS total
FROM
    report_queue_agents
WHERE
    ACTION = "RINGNOANSWER"
GROUP BY
    period,
    time_60
ORDER BY
    period,
    time_60;

CREATE TABLE dashboard_call_noanswer_week AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%u") AS period,
    Date_format(
        Sec_to_time(
            Time_to_sec(From_unixtime(timestamp_in)) - Time_to_sec(From_unixtime(timestamp_in)) % (60 * 60) + (60 * 60)
        ),
        "%H:%i"
    ) AS time_60,
    count(*) AS total
FROM
    report_queue_agents
WHERE
    ACTION = "RINGNOANSWER"
GROUP BY
    period,
    time_60
ORDER BY
    period,
    time_60;

CREATE TABLE dashboard_call_noanswer_day AS
SELECT
    Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS period,
    Date_format(
        Sec_to_time(
            Time_to_sec(From_unixtime(timestamp_in)) - Time_to_sec(From_unixtime(timestamp_in)) % (60 * 60) + (60 * 60)
        ),
        "%H:%i"
    ) AS time_60,
    count(*) AS total
FROM
    report_queue_agents
WHERE
    ACTION = "RINGNOANSWER"
GROUP BY
    period,
    time_60
ORDER BY
    period,
    time_60;