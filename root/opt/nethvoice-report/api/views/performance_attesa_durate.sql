DROP TABLE IF EXISTS performance_attesa_durate_year;
DROP TABLE IF EXISTS performance_attesa_durate_month;
DROP TABLE IF EXISTS performance_attesa_durate_week;
DROP TABLE IF EXISTS performance_attesa_durate_day;

CREATE TABLE performance_attesa_durate_year AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y") AS period, qname, max(hold) AS max_hold, min(hold) AS min_hold, avg(hold) AS avg_hold, max(duration) AS max_duration, min(nullif(duration,0)) AS min_duration, avg(duration) AS avg_duration,qdescr FROM report_queue WHERE action='ANSWER' GROUP BY period,qname;

CREATE TABLE performance_attesa_durate_month AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m") AS period, qname, max(hold) AS max_hold, min(hold) AS min_hold, avg(hold) AS avg_hold, max(duration) AS max_duration, min(nullif(duration,0)) AS min_duration, avg(duration) AS avg_duration,qdescr FROM report_queue WHERE action='ANSWER' GROUP BY period,qname;

CREATE TABLE performance_attesa_durate_week AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%u") AS period, qname, max(hold) AS max_hold, min(hold) AS min_hold, avg(hold) AS avg_hold, max(duration) AS max_duration, min(nullif(duration,0)) AS min_duration, avg(duration) AS avg_duration,qdescr FROM report_queue WHERE action='ANSWER' GROUP BY period,qname;

CREATE TABLE performance_attesa_durate_day AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y-%m-%d") AS period, qname, max(hold) AS max_hold, min(hold) AS min_hold, avg(hold) AS avg_hold, max(duration) AS max_duration, min(nullif(duration,0)) AS min_duration, avg(duration) AS avg_duration,qdescr FROM report_queue WHERE action='ANSWER' GROUP BY period,qname;
