SELECT
    period AS period£{{ .Time.Group }}Date,
    qname,
    qdescr,
    uniqCid AS uniqCid£num,
    num AS num£num,
    max_hold AS waiting$max_hold£seconds,
    min_hold AS waiting$min_hold£seconds,
    avg_hold AS waiting$avg_hold£seconds,
    max_in_pos AS duration$max_in_pos£seconds,
    avg_in_pos AS duration$avg_in_pos£seconds,
    max_out_pos AS position$max_out_pos£num,
    avg_out_pos AS position$avg_out_pos£num
FROM
    data_summary_timeout_{{ .Time.Group }}
WHERE   TRUE
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
        {{ if gt (len .Queues) 0 }}
            AND qname in ({{ ExtractStrings .Queues }})
        {{ end }}
LIMIT {{ ExtractSettings "QueryLimit" }}
