SELECT CONCAT(qdescr, " (", qname, ")") AS qdescr,
       time_{{ .Time.Division  }} AS time£{{ .Time.Group }}Date,
       total AS total£num
FROM   distribution_hour_{{ .Time.Group }}_{{ .Time.Division }}
WHERE  time_{{ .Time.Division  }} >= '{{ ExtractSettings "StartHour" }}' AND time_{{ .Time.Division  }} <= '{{ ExtractSettings "EndHour" }}'
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
        {{ if gt (len .Queues) 0 }}
                AND qname in ({{ ExtractStrings .Queues }})
        {{ end }}
        {{ if gt (len .Agents) 0 }}
                AND agent in ({{ ExtractStrings .Agents }})
        {{ end }}
GROUP BY qdescr, time£{{ .Time.Group }}Date
ORDER BY qdescr, time£{{ .Time.Group }}Date
