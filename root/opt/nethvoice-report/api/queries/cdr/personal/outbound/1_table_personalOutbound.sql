SELECT  *
FROM    `<CDR_TABLE>`
WHERE   calldate >= "{{ .Time.Interval.Start }}"
        AND calldate <= "{{ .Time.Interval.End }}"
        AND type = "OUT"
        AND src IN ({{ ExtractUserExtensions .CurrentUser }})
