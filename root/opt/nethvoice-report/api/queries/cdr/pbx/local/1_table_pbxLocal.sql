SELECT	*
FROM	`<CDR_TABLE>`
WHERE	calldate >= "{{ .Time.Interval.Start }}"
	AND calldate <= "{{ .Time.Interval.End }}"
	AND type = "LOCAL"
	{{ if gt (len .Sources) 0 }}
	  AND src IN ({{ ExtractStrings .Sources }})
	{{ end }}
	{{ if gt (len .Destinations) 0 }}
	  AND dst IN ({{ ExtractStrings .Destinations }})
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
