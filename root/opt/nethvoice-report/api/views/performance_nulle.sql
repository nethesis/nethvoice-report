DROP TABLE IF EXISTS performance_nulle_year;
DROP TABLE IF EXISTS performance_nulle_month;
DROP TABLE IF EXISTS performance_nulle_week;
DROP TABLE IF EXISTS performance_nulle_day;

CREATE TABLE performance_nulle_year AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y") AS period, qname, count(id) as count FROM report_queue WHERE (action='ABANDON' and hold<=5) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_nulle_month AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m") AS period, qname, count(id) as count FROM report_queue WHERE (action='ABANDON' and hold<=5) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_nulle_week AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%u") AS period, qname, count(id) as count FROM report_queue WHERE (action='ABANDON' and hold<=5) GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_nulle_day AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m-%d") AS period, qname, count(id) as count FROM report_queue WHERE (action='ABANDON' and hold<=5) GROUP BY period,qname ORDER BY period ASC;
