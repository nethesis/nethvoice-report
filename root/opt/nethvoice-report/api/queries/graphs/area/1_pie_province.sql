{{ if gt (len .Queues) 0  }}
SELECT provincia, 
       sum(total) AS total£num
FROM   distribution_geo_{{ .Time.Group }}
WHERE  TRUE
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
        {{ if gt (len .Queues) 0 }}
                AND qname in ({{ ExtractStrings .Queues }})
        {{ end }}
GROUP BY provincia
ORDER  BY total DESC,
          provincia;
{{ else }}
SELECT "queues field is required" AS "!message";
{{ end }}
~                    
