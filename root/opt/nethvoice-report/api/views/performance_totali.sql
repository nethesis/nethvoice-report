DROP TABLE IF EXISTS performance_totali_year;
DROP TABLE IF EXISTS performance_totali_month;
DROP TABLE IF EXISTS performance_totali_week;
DROP TABLE IF EXISTS performance_totali_day;

CREATE TABLE performance_totali_year AS SELECT p_a_d.period,p_a_d.qname,Sum((SELECT COALESCE(Sum(count), 0) 
            FROM   performance_evase_year 
            WHERE  period = p_a_d.period 
                   AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_nulle_year 
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_fallite_year 
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_timeout_year 
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_exitempty_year 
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_exitkey_year 
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_full_year 
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_joinempty_year 
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname)) AS total 
FROM   performance_attesa_durate_year p_a_d 
GROUP  BY p_a_d.period, 
          p_a_d.qname; 

CREATE TABLE performance_totali_month AS SELECT p_a_d.period,p_a_d.qname,Sum((SELECT COALESCE(Sum(count), 0)
            FROM   performance_evase_month
            WHERE  period = p_a_d.period
                   AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_nulle_month
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_fallite_month
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_timeout_month
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_exitempty_month
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_exitkey_month
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_full_month
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_joinempty_month
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname)) AS total
FROM   performance_attesa_durate_month p_a_d
GROUP  BY p_a_d.period,
          p_a_d.qname;

CREATE TABLE performance_totali_week AS SELECT p_a_d.period,p_a_d.qname,Sum((SELECT COALESCE(Sum(count), 0)
            FROM   performance_evase_week
            WHERE  period = p_a_d.period
                   AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_nulle_week
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_fallite_week
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_timeout_week
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_exitempty_week
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_exitkey_week
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_full_week
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_joinempty_week
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)) AS total
FROM   performance_attesa_durate_week p_a_d
GROUP  BY p_a_d.period,
          p_a_d.qname;

CREATE TABLE performance_totali_day AS SELECT p_a_d.period,p_a_d.qname,Sum((SELECT COALESCE(Sum(count), 0)
            FROM   performance_evase_day
            WHERE  period = p_a_d.period
                   AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_nulle_day
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_fallite_day
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_timeout_day
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_exitempty_day
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_exitkey_day
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_full_day
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)
           + (SELECT COALESCE(Sum(count), 0)
              FROM   performance_joinempty_day
              WHERE  period = p_a_d.period
                     AND qname = p_a_d.qname)) AS total
FROM   performance_attesa_durate_day p_a_d
GROUP  BY p_a_d.period,
          p_a_d.qname;

