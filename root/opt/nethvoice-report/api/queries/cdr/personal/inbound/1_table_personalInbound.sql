SELECT	*
FROM	`<CDR_TABLE>`
WHERE	calldate >= "{{ .Time.Interval.Start }}"
	AND calldate <= "{{ .Time.Interval.End }}"
	AND type = "IN"
	{{ if gt (len .Sources) 0 }}
	  AND src IN ({{ ExtractStrings .Sources }})
	{{ end }}
	{{ if gt (len .Destinations) 0 }}
	  AND dst IN ({{ ExtractStrings .Destinations }})
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
