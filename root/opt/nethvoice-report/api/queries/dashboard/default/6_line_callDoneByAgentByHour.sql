{{ if gt (len .Agents) 0 }}
SELECT
    CONCAT(agentName, " (", agentNum, ")") AS agent,
    time_60 AS `time£hourDate`,
    Sum(total) AS `num£num`
FROM
    distribution_hour_agent_{{ .Time.Group }}_60
WHERE  time_60 >= '{{ ExtractSettings "StartHour" }}' AND time_60 <= '{{ ExtractSettings "EndHour" }}'
    {{ if and .Time.Interval.Start .Time.Interval.End }}
        AND period >= "{{ .Time.Interval.Start }}"
        AND period <= "{{ .Time.Interval.End }}"
    {{ end }}
    {{ if gt (len .Agents) 0 }}
            AND agent in ({{ ExtractStrings .Agents }})
    {{ end }}
GROUP BY
    time_60,
    agent
ORDER BY
    agent,
    time_60;
{{ else }}
SELECT "agents field is required" AS "!message";
{{ end }}