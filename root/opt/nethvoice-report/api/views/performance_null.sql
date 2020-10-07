DROP TABLE IF EXISTS performance_null_year;
DROP TABLE IF EXISTS performance_null_month;
DROP TABLE IF EXISTS performance_null_week;
DROP TABLE IF EXISTS performance_null_day;

CREATE TABLE performance_null_year AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y") AS period, qname, count(id) as count FROM report_queue WHERE (action='ABANDON' and hold<=5) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_null_month AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m") AS period, qname, count(id) as count FROM report_queue WHERE (action='ABANDON' and hold<=5) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_null_week AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%u") AS period, qname, count(id) as count FROM report_queue WHERE (action='ABANDON' and hold<=5) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_null_day AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m-%d") AS period, qname, count(id) as count FROM report_queue WHERE (action='ABANDON' and hold<=5) GROUP BY period,qname ORDER BY period ASC;
