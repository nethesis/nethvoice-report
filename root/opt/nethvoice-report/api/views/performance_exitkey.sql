DROP TABLE IF EXISTS performance_exitkey_year;
DROP TABLE IF EXISTS performance_exitkey_month;
DROP TABLE IF EXISTS performance_exitkey_week;
DROP TABLE IF EXISTS performance_exitkey_day;

CREATE TABLE performance_exitkey_year AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y") AS period, qname, count(id) as count FROM report_queue WHERE action='EXITWITHKEY' GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_exitkey_month AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m") AS period, qname, count(id) as count FROM report_queue WHERE action='EXITWITHKEY' GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_exitkey_week AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%u") AS period, qname, count(id) as count FROM report_queue WHERE action='EXITWITHKEY' GROUP BY period,qname ORDER BY period ASC;

CREATE TABLE performance_exitkey_day AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m-%d") AS period, qname, count(id) as count FROM report_queue WHERE action='EXITWITHKEY' GROUP BY period,qname ORDER BY period ASC;
