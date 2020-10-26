{{ if gt (len .IVRs) 0 }}
SELECT
	period AS period£{{ .Time.Group }}Date,
	ivr_id AS `qname`,
	ivr_name,
	choice,
	time_{{ .Time.Division  }} AS `time£num^pivot`,
	total AS `{{ ExtractSettings "StartHour" }}-{{ ExtractSettings "EndHour" }}^sum_total£num`
FROM	distribution_hour_ivr_{{ .Time.Group }}_{{ .Time.Division  }}
WHERE   time_{{ .Time.Division  }} >= '{{ ExtractSettings "StartHour" }}' AND time_{{ .Time.Division  }} <= '{{ ExtractSettings "EndHour" }}'
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
	{{ if gt (len .Choices) 0 }}
            AND choice in ({{ ExtractStrings .Choices }})
        {{ end }}
        {{ if gt (len .IVRs) 0 }}
            AND ivr_name in ({{ ExtractStrings .IVRs }})
        {{ end }}
GROUP BY period, time_{{ .Time.Division }},qdescr
ORDER BY period, ivr_id, time_{{ .Time.Division }}
{{ else }}
SELECT "ivrs field is required" AS "!message";
{{ end }}
