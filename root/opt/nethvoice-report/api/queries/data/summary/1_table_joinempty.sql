SELECT
    period AS period£{{ .Time.Group }}Date,
    qname,
    qdescr,
    uniqCid AS uniqCid£num,
    num AS num£num
FROM
    summary_joinempty_{{ .Time.Group }}
WHERE   TRUE
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
        {{ if gt (len .Queues) 0 }}
            AND qname in ({{ StringsJoin .Queues "," }})
        {{ end }};