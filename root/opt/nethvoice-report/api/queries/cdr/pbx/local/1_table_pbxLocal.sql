SELECT
    linkedid,
    DATE_FORMAT(calldate, '%Y-%m-%d %H:%i:%s') AS time£hourDate,
    src AS src£phoneNumber,
    dst AS dst£phoneNumber,
    type AS call_type£label,
    SUBSTRING_INDEX(dispositions, ',',- 1) AS result£label, -- get last disposition
    duration AS totalDuration£seconds,
    billsec AS billsec£seconds
FROM	`<CDR_TABLE>`
WHERE	calldate >= "{{ .Time.Interval.Start }}"
	AND calldate <= "{{ .Time.Interval.End }}"
	AND type = "LOCAL"
	{{ if (and (gt (len .Sources) 0) (gt (len .Destinations) 0)) }}
          AND (src IN ({{ ExtractStrings .Sources }}) AND dst IN ({{ ExtractStrings .Destinations }}))
        {{ else if gt (len .Sources) 0 }}
          AND src IN ({{ ExtractStrings .Sources }})
        {{ else if gt (len .Destinations) 0 }}
          AND dst IN ({{ ExtractStrings .Destinations }})
        {{ else }}
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
