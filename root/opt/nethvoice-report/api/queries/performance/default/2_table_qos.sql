SELECT responseTime£label,
       answer£num,
       percentage£percent
FROM   (SELECT "total"                           AS responseTime£label,
                (SELECT SUM(count)
                        FROM   performance_qos_total
                        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
                        AND timestamp_in >= "{{ .Time.Interval.Start }}"
                        AND timestamp_out <= "{{ .Time.Interval.End }}"
                        {{ end }}
                        {{ if gt (len .Queues) 0 }}
                        AND qname in ({{ ExtractStrings .Queues }})
                        {{ end }}) AS answer£num,
                100 as percentage£percent
        UNION
        SELECT "5sec"                           AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_5
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_5
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "10sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_10
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_10
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "15sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_15
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_15
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "20sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_20
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_20
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "25sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_25
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_25
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "30sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_30
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_30
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "45sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_45
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_45
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "60sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_60
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_60
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "75sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_75
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_75
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "90sec"                          AS responseTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_qos_total_90
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS answer£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_qos_total_90
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_qos_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}"
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent) AS responseTime£labels;