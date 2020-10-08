SELECT p_a_d.period, 
       p_a_d.qname AS queueName,
       p_a_d.qdescr AS queueDescription,
       (SELECT total 
        FROM   performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }} 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS incoming, 
       (SELECT count 
        FROM   performance_processed_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }} 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS processed$tot, 
       ( Round((SELECT count 
                FROM   performance_processed_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / 
               (SELECT total 
                FROM   performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname), 
           2) )                                       AS processed$percentage$percent, 
       (SELECT count 
        FROM   performance_good_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }} 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS processed$60sec, 
       ( Round((SELECT count 
                FROM   performance_good_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }} 
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS processed$percentage$percent, 
       Sum((SELECT COALESCE(Sum(count), 0) 
            FROM   performance_failed_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }} 
            WHERE  period = p_a_d.period 
                   AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_timeout_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_exitempty_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_exitkey_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_full_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname) 
           + (SELECT COALESCE(Sum(count), 0) 
              FROM   performance_joinempty_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
              WHERE  period = p_a_d.period 
                     AND qname = p_a_d.qname))        AS notProcessed$tot, 
       ( Round(( Sum((SELECT COALESCE(Sum(count), 0) 
                      FROM   performance_failed_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                      WHERE  period = p_a_d.period 
                             AND qname = p_a_d.qname) 
                     + (SELECT COALESCE(Sum(count), 0) 
                        FROM   performance_timeout_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                        WHERE  period = p_a_d.period 
                               AND qname = p_a_d.qname) 
                     + (SELECT COALESCE(Sum(count), 0) 
                        FROM   performance_exitempty_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                        WHERE  period = p_a_d.period 
                               AND qname = p_a_d.qname) 
                     + (SELECT COALESCE(Sum(count), 0) 
                        FROM   performance_exitkey_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }} 
                        WHERE  period = p_a_d.period 
                               AND qname = p_a_d.qname) 
                     + (SELECT COALESCE(Sum(count), 0) 
                        FROM   performance_full_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                        WHERE  period = p_a_d.period 
                               AND qname = p_a_d.qname) 
                     + (SELECT COALESCE(Sum(count), 0) 
                        FROM   performance_joinempty_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                        WHERE  period = p_a_d.period 
                               AND qname = p_a_d.qname)) ) * 100 / (SELECT total 
                                                                    FROM 
                       performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                                                                    WHERE 
                       period = p_a_d.period 
                       AND qname = p_a_d.qname), 2) ) AS notProcessed$percentage$percent, 
       (SELECT Sum(count) 
        FROM   performance_failed_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$failed, 
       ( Round((SELECT Sum(count) 
                FROM   performance_failed_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS notProcessed$percentage$percent, 
       (SELECT Sum(count) 
        FROM   performance_timeout_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$timeout, 
       ( Round((SELECT Sum(count) 
                FROM   performance_timeout_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS notProcessed$percentage$percent, 
       (SELECT Sum(count) 
        FROM   performance_exitempty_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$exitempty, 
       ( Round((SELECT Sum(count) 
                FROM   performance_exitempty_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS notProcessed$percentage$percent, 
       (SELECT Sum(count) 
        FROM   performance_exitkey_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$exitkey, 
       ( Round((SELECT Sum(count) 
                FROM   performance_exitkey_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS notProcessed$percentage$percent, 
       (SELECT Sum(count) 
        FROM   performance_full_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$full, 
       ( Round((SELECT Sum(count) 
                FROM   performance_full_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS notProcessed$percentage$percent, 
       (SELECT Sum(count) 
        FROM   performance_joinempty_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS notProcessed$joinempty, 
       ( Round((SELECT Sum(count) 
                FROM   performance_joinempty_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS notProcessed$percentage$percent, 
       (SELECT Sum(count) 
        FROM   performance_null_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname)               AS null$tot, 
       ( Round((SELECT Sum(count) 
                FROM   performance_null_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                WHERE  period = p_a_d.period 
                       AND qname = p_a_d.qname) * 100 / (SELECT total 
                                                         FROM 
               performance_total_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }}
                                                         WHERE 
               period = p_a_d.period 
               AND qname = 
           p_a_d.qname), 2) )                         AS null$percentage$percent, 
       p_a_d.min_hold                                 AS waiting$min$seconds, 
       p_a_d.max_hold                                 AS waiting$max$seconds, 
       p_a_d.avg_hold                                 AS waiting$avg$seconds, 
       p_a_d.min_duration                             AS duration$min$seconds, 
       p_a_d.max_duration                             AS duration$max$seconds, 
       p_a_d.avg_duration                             AS duration$avg$seconds 
FROM   performance_wait_duration_{{ if .Time.Group }}{{ .Time.Group }}{{ else }}year{{ end }} p_a_d 
GROUP  BY p_a_d.period, 
          p_a_d.qname; 
