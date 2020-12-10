SELECT	*
FROM	`<CDR_TABLE>`
WHERE	calldate >= "{{ .Time.Interval.Start }}"
	AND calldate <= "{{ .Time.Interval.End }}"
	AND type = "OUT"
	{{ if (and (gt (len .Sources) 0) (gt (len .Destinations) 0)) }}
          AND (src IN ({{ ExtractStrings .Sources }}) OR dst IN ({{ ExtractStrings .Destinations }}))
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
        {{ if gt (len .Patterns) 0 }}
	  AND call_type IN ({{ ExtractStrings .Patterns }})
        {{ end }}
