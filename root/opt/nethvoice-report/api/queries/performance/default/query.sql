SELECT p_a_d.period, 
       p_a_d.qname, 
       (SELECT total 
        FROM   performance_totali_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS incoming, 
       (SELECT count 
        FROM   performance_evase_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS processed$tot, 
       ( Round((SELECT count 
                FROM   performance_evase_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / 
               (SELECT total 
                FROM   performance_totali_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname), 
           2) )                                       AS percentage, 
       (SELECT count 
        FROM   performance_good_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS processed$60sec, 
       ( Round((SELECT count 
                FROM   performance_good_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_totali_year 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS percentage, 
       Sum((SELECT COALESCE(Sum(count), 0) 
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
                     AND qname = p_a_d.qname))        AS notProcessed$tot, 
       ( Round(( Sum((SELECT COALESCE(Sum(count), 0) 
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
                               AND qname = p_a_d.qname)) ) * 100 / (SELECT total 
                                                                    FROM 
                       performance_totali_year 
                                                                    WHERE 
                       period = p_a_d.period 
                       AND qname = p_a_d.qname), 2) ) AS percentage, 
       (SELECT Sum(count) 
        FROM   performance_fallite_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$fallite, 
       ( Round((SELECT Sum(count) 
                FROM   performance_fallite_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_totali_year 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS percentage, 
       (SELECT Sum(count) 
        FROM   performance_timeout_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$timeout, 
       ( Round((SELECT Sum(count) 
                FROM   performance_timeout_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_totali_year 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS percentage, 
       (SELECT Sum(count) 
        FROM   performance_exitempty_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$exitempty, 
       ( Round((SELECT Sum(count) 
                FROM   performance_exitempty_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_totali_year 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS percentage, 
       (SELECT Sum(count) 
        FROM   performance_exitkey_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$exitkey, 
       ( Round((SELECT Sum(count) 
                FROM   performance_exitkey_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_totali_year 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS percentage, 
       (SELECT Sum(count) 
        FROM   performance_full_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$full, 
       ( Round((SELECT Sum(count) 
                FROM   performance_full_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_totali_year 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS percentage, 
       (SELECT Sum(count) 
        FROM   performance_joinempty_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$joinempty, 
       ( Round((SELECT Sum(count) 
                FROM   performance_joinempty_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_totali_year 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS percentage, 
       (SELECT Sum(count) 
        FROM   performance_nulle_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS null$tot, 
       ( Round((SELECT Sum(count) 
                FROM   performance_nulle_year 
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_totali_year 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS percentage, 
       p_a_d.min_hold                                 AS waiting$min, 
       p_a_d.max_hold                                 AS waiting$max, 
       p_a_d.avg_hold                                 AS waiting$avg, 
       p_a_d.min_duration                             AS duration$min, 
       p_a_d.max_duration                             AS duration$max, 
       p_a_d.avg_duration                             AS duration$avg 
FROM   performance_attesa_durate_year p_a_d 
GROUP  BY p_a_d.period, 
          p_a_d.qname; 
