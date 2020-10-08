SELECT (SELECT SUM(count) 
        FROM   performance_qos_total 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS total, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_5 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 5count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_5 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       5count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_10 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 10count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_10 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       10count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_15 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 15count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_15 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       15count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_20 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 20count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_20 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       20count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_25 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 25count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_25 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       25count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_30 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 30count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_30 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       30count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_45 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 45count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_45 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       45count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_60 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 60count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_60 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       60count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_75 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 75count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_75 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       75count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_90 
        WHERE  timestamp_in >= "2018-01-01" 
               AND timestamp_out <= "2019-12-31" 
               AND qname = "4444") 
       AS 90count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_90 
                WHERE  timestamp_in >= "2018-01-01" 
                       AND timestamp_out <= "2019-12-31" 
                       AND qname = "4444") * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               timestamp_in >= "2018-01-01" 
               AND timestamp_out <= 
                   "2019-12-31" 
               AND qname = "4444"), 2) ) AS 
       90count£percent; 
