DROP TABLE IF EXISTS performance_good_year;
DROP TABLE IF EXISTS performance_good_month;
DROP TABLE IF EXISTS performance_good_week;
DROP TABLE IF EXISTS performance_good_day;

CREATE TABLE performance_good_year AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y") AS period, qname, count(id) as count FROM report_queue WHERE (action='ANSWER' and hold<60) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_good_month AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m") AS period, qname, count(id) as count FROM report_queue WHERE (action='ANSWER' and hold<60) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_good_week AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%u") AS period, qname, count(id) as count FROM report_queue WHERE (action='ANSWER' and hold<60) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_good_day AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m-%d") AS period, qname, count(id) as count FROM report_queue WHERE (action='ANSWER' and hold<60) GROUP BY period,qname ORDER BY period ASC;
