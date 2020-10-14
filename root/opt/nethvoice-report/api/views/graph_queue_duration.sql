DROP TABLE IF EXISTS graph_queue_duration_year_10; 
DROP TABLE IF EXISTS graph_queue_duration_year_15; 
DROP TABLE IF EXISTS graph_queue_duration_year_30; 
DROP TABLE IF EXISTS graph_queue_duration_year_60; 

CREATE TABLE graph_queue_duration_year_10 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 10 * 60 ) + ( 10 * 
                   60 )), "%H:%i") AS 
       time_10, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_10 
ORDER  BY period, 
          time_10; 

CREATE TABLE graph_queue_duration_year_15 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 15 * 60 ) + ( 15 * 
                   60 )), "%H:%i") AS 
       time_15, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey"
GROUP  BY qdescr, 
          period, 
          time_15 
ORDER  BY period, 
          time_15; 

CREATE TABLE graph_queue_duration_year_30 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 30 * 60 ) + ( 30 * 
                   60 )), "%H:%i") AS 
       time_30, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_30 
ORDER  BY period, 
          time_30; 

CREATE TABLE graph_queue_duration_year_60 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 60 * 60 ) + ( 60 * 
                   60 )), "%H:%i") AS 
       time_60, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey"
GROUP  BY qdescr, 
          period, 
          time_60 
ORDER  BY period, 
          time_60;  

DROP TABLE IF EXISTS graph_queue_duration_month_10; 
DROP TABLE IF EXISTS graph_queue_duration_month_15; 
DROP TABLE IF EXISTS graph_queue_duration_month_30; 
DROP TABLE IF EXISTS graph_queue_duration_month_60;

CREATE TABLE graph_queue_duration_month_10 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 10 * 60 ) + ( 10 * 
                   60 )), "%H:%i") AS 
       time_10, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_10 
ORDER  BY period, 
          time_10; 

CREATE TABLE graph_queue_duration_month_15 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 15 * 60 ) + ( 15 * 
                   60 )), "%H:%i") AS 
       time_15, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_15 
ORDER  BY period, 
          time_15; 

CREATE TABLE graph_queue_duration_month_30 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 30 * 60 ) + ( 30 * 
                   60 )), "%H:%i") AS 
       time_30, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_30 
ORDER  BY period, 
          time_30; 

CREATE TABLE graph_queue_duration_month_60 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 60 * 60 ) + ( 60 * 
                   60 )), "%H:%i") AS 
       time_60, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey"
GROUP  BY qdescr, 
          period, 
          time_60 
ORDER  BY period, 
          time_60;  

DROP TABLE IF EXISTS graph_queue_duration_week_10; 
DROP TABLE IF EXISTS graph_queue_duration_week_15; 
DROP TABLE IF EXISTS graph_queue_duration_week_30; 
DROP TABLE IF EXISTS graph_queue_duration_week_60;

CREATE TABLE graph_queue_duration_week_10 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%u") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 10 * 60 ) + ( 10 * 
                   60 )), "%H:%i") AS 
       time_10, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_10 
ORDER  BY period, 
          time_10; 

CREATE TABLE graph_queue_duration_week_15 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%u") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 15 * 60 ) + ( 15 * 
                   60 )), "%H:%i") AS 
       time_15, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_15 
ORDER  BY period, 
          time_15; 

CREATE TABLE graph_queue_duration_week_30 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%u") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 30 * 60 ) + ( 30 * 
                   60 )), "%H:%i") AS 
       time_30, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_30 
ORDER  BY period, 
          time_30; 

CREATE TABLE graph_queue_duration_week_60 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%u") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 60 * 60 ) + ( 60 * 
                   60 )), "%H:%i") AS 
       time_60, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey"
GROUP  BY qdescr, 
          period, 
          time_60 
ORDER  BY period, 
          time_60;  

DROP TABLE IF EXISTS graph_queue_duration_day_10; 
DROP TABLE IF EXISTS graph_queue_duration_day_15; 
DROP TABLE IF EXISTS graph_queue_duration_day_30; 
DROP TABLE IF EXISTS graph_queue_duration_day_60;

CREATE TABLE graph_queue_duration_day_10 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 10 * 60 ) + ( 10 * 
                   60 )), "%H:%i") AS 
       time_10, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_10 
ORDER  BY period, 
          time_10; 

CREATE TABLE graph_queue_duration_day_15 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 15 * 60 ) + ( 15 * 
                   60 )), "%H:%i") AS 
       time_15, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_15 
ORDER  BY period, 
          time_15; 

CREATE TABLE graph_queue_duration_day_30 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 30 * 60 ) + ( 30 * 
                   60 )), "%H:%i") AS 
       time_30, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey" 
GROUP  BY qdescr, 
          period, 
          time_30 
ORDER  BY period, 
          time_30; 

CREATE TABLE graph_queue_duration_day_60 AS SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") 
       AS 
       period, 
       qname, 
       qdescr, 
       Date_format(Sec_to_time(Time_to_sec(From_unixtime(timestamp_in)) - 
                               Time_to_sec(From_unixtime ( 
                                           timestamp_in))%( 60 * 60 ) + ( 60 * 
                   60 )), "%H:%i") AS 
       time_60, 
       Avg(duration) 
       AS avg_duration 
FROM   report_queue 
WHERE  NOT action = "exitwithkey"
GROUP  BY qdescr, 
          period, 
          time_60 
ORDER  BY period, 
          time_60;  
