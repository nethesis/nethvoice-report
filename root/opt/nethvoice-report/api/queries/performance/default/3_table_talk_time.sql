SELECT talkTime£label,
       duration£num,
       percentage£percent
FROM   (SELECT "total"                           AS talkTime£label,
                (SELECT SUM(count)
                        FROM   performance_talk_time_total
                        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
                        {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
                        {{ end }}
                        {{ if gt (len .Queues) 0 }}
                        AND qname in ({{ ExtractStrings .Queues }})
                        {{ end }}) AS duration£num,
                100 as percentage£percent
        UNION
        SELECT "5sec"                           AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_5
                WHERE  true
                     {{ if and .Time.Interval.Start .Time.Interval.End }}
                        {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
                     {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_5
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "10sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_10
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_10
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "15sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_15
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_15
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "20sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_20
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_20
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "25sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_25
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_25
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "30sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_30
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_30
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "45sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_45
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_45
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "60sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_60
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_60
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "75sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_75
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_75
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent
        UNION
        SELECT "90sec"                          AS talkTime£label,
               (SELECT Sum(count) AS count
                FROM   performance_talk_time_total_90
                WHERE  true
                       {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) AS duration£num,
               ( Round((SELECT Sum(count) AS count
                        FROM   performance_talk_time_total_90
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}) * 100 /
                       (SELECT Sum(count)
                        FROM   performance_talk_time_total
                        WHERE  true
                               {{ if and .Time.Interval.Start .Time.Interval.End }}
               {{ if eq .Time.Group "year" }}
                        AND date_format(timestamp_in, "%Y") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "month" }}
                        AND date_format(timestamp_in, "%Y-%m") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m") <= "{{ .Time.Interval.End }}"
                        {{ else if eq .Time.Group "week" }}
                        AND date_format(timestamp_in, "%Y-%u") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%u") <= "{{ .Time.Interval.End }}"
                        {{ else }}
                        AND date_format(timestamp_in, "%Y-%m-%d") >= "{{ .Time.Interval.Start }}"
                        AND date_format(timestamp_out, "%Y-%m-%d") <= "{{ .Time.Interval.End }}"
                        {{ end }}
               {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ ExtractStrings .Queues }})
               {{ end }}),
                   2) )                         AS percentage£percent) AS talkTime£labels;
