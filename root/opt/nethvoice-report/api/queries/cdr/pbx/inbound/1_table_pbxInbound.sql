SELECT
    linkedid,
    DATE_FORMAT(calldate, '%Y-%m-%d %H:%i:%s') AS time£hourDate,
    cnum AS src£phoneNumber,
    dst AS dst£phoneNumber,
    type AS call_type£label,
    SUBSTRING_INDEX(dispositions, ',',- 1) AS result£label, -- get last disposition
    duration AS totalDuration£seconds,
    billsec AS billsec£seconds,
	did
FROM	`<CDR_TABLE>`
WHERE	calldate >= "{{ .Time.Interval.Start }}"
	AND calldate <= "{{ .Time.Interval.End }}"
	AND type = "IN"
	{{ if (and (gt (len .Sources) 0) (gt (len .Destinations) 0)) }}
          AND (cnum REGEXP ({{ ExtractRegexpStrings .Sources }}) AND dst REGEXP ({{ ExtractRegexpStrings .Destinations }}))
        {{ else if gt (len .Sources) 0 }}
          AND cnum REGEXP ({{ ExtractRegexpStrings .Sources }})
        {{ else if gt (len .Destinations) 0 }}
          AND dst REGEXP ({{ ExtractRegexpStrings .Destinations }})
        {{ else }}
        {{ end }}
	{{ if gt (len .DIDs) 0 }}
	  AND did REGEXP ({{ ExtractRegexpStrings .DIDs}})
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
