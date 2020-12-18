SELECT type,
       call_type,	
       Count(*)                                                 AS "total£num", 
       Sum(IF(dispositions REGEXP 'ANSWERED$', 1, 0))           AS "answered£num", 
       Sum(IF(dispositions REGEXP 'NO ANSWER$', 1, 0))          AS "noAnswer£num", 
       Sum(IF(dispositions REGEXP 'BUSY$', 1, 0))               AS "busy£num", 
       Sum(IF(( dispositions REGEXP 'FAILED$' 
                 OR dispositions REGEXP 'CONGESTION$' ), 1, 0)) AS "failed£num",
       Sum(duration)						AS "totalDuration£seconds",	
       Avg(duration)                                            AS "avgDuration£seconds",
       Sum(COALESCE(cost,0))					AS "totalCost£currency",
       Avg(COALESCE(cost,0))                                    AS "avgCost£currency", 
       Sum(duration) - Sum(billsec)				AS "totalWait£seconds",
       Avg(duration) - Avg(billsec)                             AS "avgWait£seconds" 
FROM   `<CDR_TABLE>`
WHERE	calldate >= "{{ .Time.Interval.Start }}"
	AND calldate <= "{{ .Time.Interval.End }}"
	{{ if (and (gt (len .Sources) 0) (gt (len .Destinations) 0)) }}
          AND (src IN ({{ ExtractStrings .Sources }}) OR dst IN ({{ ExtractStrings .Destinations }}))
        {{ else if gt (len .Sources) 0 }}
          AND src IN ({{ ExtractStrings .Sources }})
        {{ else if gt (len .Destinations) 0 }}
          AND dst IN ({{ ExtractStrings .Destinations }})
        {{ else }}
        {{ end }}
	{{ if gt (len .DIDs) 0 }}
	  AND did IN ({{ ExtractStrings .DIDs}})
	{{ end }}
	{{ if .CallType }}
	  AND dispositions REGEXP "{{ .CallType }}$"
	{{ end }}
	{{ if .Duration }}
	  AND duration <= {{ .Duration }}
	{{ end }}
	{{ if gt (len .Trunks) 0 }}
	  AND channel LIKE "%{{ .Trunks }}%"
	{{ end }}
	{{ if gt (len .CallDestinations) 0 }}
	  {{ ExtractCallDestinations .CallDestinations }}
	{{ end }}
<CDR_GROUP: type, call_type>
<CDR_ORDER: type, call_type>
