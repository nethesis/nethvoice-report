SELECT period AS period£{{ .Time.Group }}Date,
       qname, 
       qdescr, 
       prefisso, 
       comune, 
       provincia, 
       regione, 
       total AS total£num 
FROM   distribution_geo_{{ .Time.Group }} 
WHERE  TRUE 
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
        {{ if gt (len .Queues) 0 }}
                AND qname in ({{ ExtractStrings .Queues }})
        {{ end }}  
        {{ if gt (len .Origins) 0 }}
                AND ({{ ExtractOrigins .Origins false }})
        {{ end }}
