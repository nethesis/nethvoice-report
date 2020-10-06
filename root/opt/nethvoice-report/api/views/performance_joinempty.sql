DROP TABLE IF EXISTS performance_joinempty_year;
DROP TABLE IF EXISTS performance_joinempty_month;
DROP TABLE IF EXISTS performance_joinempty_week;
DROP TABLE IF EXISTS performance_joinempty_day;

CREATE TABLE performance_joinempty_year AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y") AS period, qname, count(id) as count FROM report_queue WHERE action='JOINEMPTY' GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_joinempty_month AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m") AS period, qname, count(id) as count FROM report_queue WHERE action='JOINEMPTY' GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_joinempty_week AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%u") AS period, qname, count(id) as count FROM report_queue WHERE action='JOINEMPTY' GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_joinempty_day AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m-%d") AS period, qname, count(id) as count FROM report_queue WHERE action='JOINEMPTY' GROUP BY period,qname ORDER BY period ASC;
