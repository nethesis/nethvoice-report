SELECT
    period AS period£{{ .Time.Group }}Date,
    agent,
    qname,
    qdescr,
    logon as activity$logonDays£days,
    login as activity$login£seconds,
    pause as activity$pause£seconds,
    login - pause as activity$effective£seconds,
    answered as load$answered£num,
    unanswered as load$unAnswered£num,
    totcall as load$totCall£seconds,
    round(answered / ((login - pause) / 3600), 2) as load$callOnHour£num,
    round(totcall / (login - pause), 2) as load$occupation£percent,
    min_duration as duration$min_duration£seconds,
    max_duration as duration$max_duration£seconds,
    avg_duration as duration$avg_duration£seconds
FROM data_agent_{{ .Time.Group }}
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
