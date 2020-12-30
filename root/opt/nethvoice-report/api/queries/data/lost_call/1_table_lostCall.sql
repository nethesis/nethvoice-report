{{ if and .Time.Interval.Start .Time.Interval.End }}
SELECT
    period as `period£hourDate`,
    qname,
    qdescr,
    cid,
    name,
    company,
    state AS state£label,
    reason AS reason£label
FROM
    data_lost
WHERE   TRUE
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
        {{ if gt (len .Phones) 0 }}
            AND cid in ({{ ExtractPhones .Phones true }})
        {{ end }}
        {{ if .Caller }}
            AND cid LIKE "{{ .Caller }}%"
        {{ end }}
        {{ if gt (len .Queues) 0 }}
            AND qname in ({{ ExtractStrings .Queues }})
        {{ end }}
        {{ if gt (len .Reasons) 0 }}
            AND reason in ({{ ExtractStrings .Reasons }})
        {{ end }}
LIMIT {{ ExtractSettings "QueryLimit" }}
{{ else }}
SELECT "timeIntervalStart and timeIntervalEnd are required" AS "!message";
{{ end }}
