{{ if gt (len .Queues) 0  }}
SELECT CONCAT(qdescr, " (", qname, ")") AS qdescr,
       time_{{ .Time.Division  }} AS time£hourDate,
       avg_position AS avgPosition£num
FROM   graph_queue_position_{{ .Time.Group }}_{{ .Time.Division }}
WHERE  TRUE
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
        {{ if gt (len .Queues) 0 }}
                AND qname in ({{ ExtractStrings .Queues }})
        {{ end }}
{{ else }}
SELECT "queues field is required" AS "!message";
{{ end }}
