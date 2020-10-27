{{ if and .Time.Interval.Start .Time.Interval.End }}
SELECT
    period AS `period£hourDate`,
    cid,
    name,
    company,
    qname,
    qdescr,
    agent,
    position,
    hold AS hold£seconds,
    duration AS duration£seconds,
    result
FROM
    data_call
WHERE TRUE
    {{ if and .Time.Interval.Start .Time.Interval.End }}
        AND period >= "{{ .Time.Interval.Start }}"
        AND period <= "{{ .Time.Interval.End }}"
    {{ end }}
    {{ if gt (len .Queues) 0 }}
        AND qname in ({{ ExtractStrings .Queues }})
    {{ end }}
    {{ if gt (len .Agents) 0 }}
        AND agent in ({{ ExtractStrings .Agents }})
    {{ end }}
    {{ if gt (len .Phones) 0 }}
        AND cid in ({{ ExtractPhones .Phones true }})
    {{ end }}
    {{ if .Caller }}
        AND cid LIKE "{{ .Caller }}%"
    {{ end }}
    {{ if gt (len .Results) 0 }}
        AND result in ({{ ExtractStrings .Results }})
    {{ end }}
ORDER BY
    period DESC;
{{ else }}
SELECT "timeIntervalStart and timeIntervalEnd are required" AS "!message";
{{ end }}