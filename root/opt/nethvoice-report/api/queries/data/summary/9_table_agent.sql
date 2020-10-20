SELECT period  AS period£{{ .Time.Group }}Date, 
       agentNum,
       agentName,
       total   AS total£num, 
       uniqcid AS uniqCid£num, 
       minbill AS duration$min_duration£seconds, 
       avgbill AS duration$avg_duration£seconds, 
       maxbill AS duration$max_duration£seconds 
FROM   data_summary_agent_{{ .Time.Group }};
WHERE   TRUE
        {{ if and .Time.Interval.Start .Time.Interval.End }}
            AND period >= "{{ .Time.Interval.Start }}"
            AND period <= "{{ .Time.Interval.End }}"
        {{ end }}
        {{ if gt (len .Agents) 0 }}
            AND agentName in ({{ ExtractStrings .Agents }})
        {{ end }};
