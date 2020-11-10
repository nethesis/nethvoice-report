DROP TABLE IF EXISTS data_agent_year; 

DROP TABLE IF EXISTS data_agent_month; 

DROP TABLE IF EXISTS data_agent_week; 

DROP TABLE IF EXISTS data_agent_day; 

CREATE TABLE data_agent_year AS 
  SELECT t1.period AS period, 
         t1.agent  AS agent, 
         t1.qname  AS qname, 
         t1.qdescr AS qdescr, 
         t2.logon  AS logon, 
         t2.work   AS login, 
         t2.pause  AS pause, 
         answered, 
         unanswered, 
         totcall, 
         min_duration, 
         max_duration, 
         avg_duration 
  FROM   (SELECT agent, 
                 qname, 
                 qdescr, 
                 Sum(IF(action = 'ANSWER', 1, 0))               AS answered, 
                 Sum(IF(action = 'RINGNOANSWER', 1, 0))         AS unanswered, 
                 Sum(duration)                                  AS totcall, 
                 Max(duration)                                  AS max_duration, 
                 Min(Nullif(duration, 0))                       AS min_duration, 
                 Avg(duration)                                  AS avg_duration, 
                 Date_format(From_unixtime(timestamp_in), '%Y') AS period 
          FROM   report_queue_agents 
          GROUP  BY agent, 
                    period, 
                    qname) t1 
         JOIN (SELECT agent, 
                      qname, 
                      Sum(IF(action IN ( 'logon', 'agent' ), 
                          timestamp_out - timestamp_in 
                          , 0)) 
                                                AS work, 
                      Sum(IF(action = 'pause', timestamp_out - timestamp_in, 0)) 
                                                AS pause, 
                      Count(DISTINCT( Date(From_unixtime(timestamp_in)) )) 
                                                AS logon, 
                      Date_format(From_unixtime(timestamp_in), '%Y') 
                                                AS period 
               FROM   agentsessions 
               GROUP  BY agent, 
                         period, 
                         qname) t2 
           ON t1.agent = t2.agent 
              AND t1.qname = t2.qname 
              AND t1.period = t2.period;

CREATE TABLE data_agent_month AS 
  SELECT t1.period AS period, 
         t1.agent  AS agent, 
         t1.qname  AS qname, 
         t1.qdescr AS qdescr, 
         t2.logon  AS logon, 
         t2.work   AS login, 
         t2.pause  AS pause, 
         answered, 
         unanswered, 
         totcall, 
         min_duration, 
         max_duration, 
         avg_duration 
  FROM   (SELECT agent, 
                 qname, 
                 qdescr, 
                 Sum(IF(action = 'ANSWER', 1, 0))               AS answered, 
                 Sum(IF(action = 'RINGNOANSWER', 1, 0))         AS unanswered, 
                 Sum(duration)                                  AS totcall, 
                 Max(duration)                                  AS max_duration, 
                 Min(Nullif(duration, 0))                       AS min_duration, 
                 Avg(duration)                                  AS avg_duration, 
                 Date_format(From_unixtime(timestamp_in), '%Y-%m') AS period 
          FROM   report_queue_agents 
          GROUP  BY agent, 
                    period, 
                    qname) t1 
         JOIN (SELECT agent, 
                      qname, 
                      Sum(IF(action IN ( 'logon', 'agent' ), 
                          timestamp_out - timestamp_in 
                          , 0)) 
                                                AS work, 
                      Sum(IF(action = 'pause', timestamp_out - timestamp_in, 0)) 
                                                AS pause, 
                      Count(DISTINCT( Date(From_unixtime(timestamp_in)) )) 
                                                AS logon, 
                      Date_format(From_unixtime(timestamp_in), '%Y-%m') 
                                                AS period 
               FROM   agentsessions 
               GROUP  BY agent, 
                         period, 
                         qname) t2 
           ON t1.agent = t2.agent 
              AND t1.qname = t2.qname 
              AND t1.period = t2.period;

CREATE TABLE data_agent_week AS 
  SELECT t1.period AS period, 
         t1.agent  AS agent, 
         t1.qname  AS qname, 
         t1.qdescr AS qdescr, 
         t2.logon  AS logon, 
         t2.work   AS login, 
         t2.pause  AS pause, 
         answered, 
         unanswered, 
         totcall, 
         min_duration, 
         max_duration, 
         avg_duration 
  FROM   (SELECT agent, 
                 qname, 
                 qdescr, 
                 Sum(IF(action = 'ANSWER', 1, 0))               AS answered, 
                 Sum(IF(action = 'RINGNOANSWER', 1, 0))         AS unanswered, 
                 Sum(duration)                                  AS totcall, 
                 Max(duration)                                  AS max_duration, 
                 Min(Nullif(duration, 0))                       AS min_duration, 
                 Avg(duration)                                  AS avg_duration, 
                 Date_format(From_unixtime(timestamp_in), '%x-W%v') AS period 
          FROM   report_queue_agents 
          GROUP  BY agent, 
                    period, 
                    qname) t1 
         JOIN (SELECT agent, 
                      qname, 
                      Sum(IF(action IN ( 'logon', 'agent' ), 
                          timestamp_out - timestamp_in 
                          , 0)) 
                                                AS work, 
                      Sum(IF(action = 'pause', timestamp_out - timestamp_in, 0)) 
                                                AS pause, 
                      Count(DISTINCT( Date(From_unixtime(timestamp_in)) )) 
                                                AS logon, 
                      Date_format(From_unixtime(timestamp_in), '%x-W%v') 
                                                AS period 
               FROM   agentsessions 
               GROUP  BY agent, 
                         period, 
                         qname) t2 
           ON t1.agent = t2.agent 
              AND t1.qname = t2.qname 
              AND t1.period = t2.period;


CREATE TABLE data_agent_day AS 
  SELECT t1.period AS period, 
         t1.agent  AS agent, 
         t1.qname  AS qname, 
         t1.qdescr AS qdescr, 
         t2.logon  AS logon, 
         t2.work   AS login, 
         t2.pause  AS pause, 
         answered, 
         unanswered, 
         totcall, 
         min_duration, 
         max_duration, 
         avg_duration 
  FROM   (SELECT agent, 
                 qname, 
                 qdescr, 
                 Sum(IF(action = 'ANSWER', 1, 0))               AS answered, 
                 Sum(IF(action = 'RINGNOANSWER', 1, 0))         AS unanswered, 
                 Sum(duration)                                  AS totcall, 
                 Max(duration)                                  AS max_duration, 
                 Min(Nullif(duration, 0))                       AS min_duration, 
                 Avg(duration)                                  AS avg_duration, 
                 Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') AS period 
          FROM   report_queue_agents 
          GROUP  BY agent, 
                    period, 
                    qname) t1 
         JOIN (SELECT agent, 
                      qname, 
                      Sum(IF(action IN ( 'logon', 'agent' ), 
                          timestamp_out - timestamp_in 
                          , 0)) 
                                                AS work, 
                      Sum(IF(action = 'pause', timestamp_out - timestamp_in, 0)) 
                                                AS pause, 
                      Count(DISTINCT( Date(From_unixtime(timestamp_in)) )) 
                                                AS logon, 
                      Date_format(From_unixtime(timestamp_in), '%Y-%m-%d') 
                                                AS period 
               FROM   agentsessions 
               GROUP  BY agent, 
                         period, 
                         qname) t2 
           ON t1.agent = t2.agent 
              AND t1.qname = t2.qname 
              AND t1.period = t2.period;
