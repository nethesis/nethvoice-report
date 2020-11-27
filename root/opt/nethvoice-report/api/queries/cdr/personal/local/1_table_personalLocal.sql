SELECT  *
FROM    `<CDR_TABLE>`
WHERE   calldate >= "{{ .Time.Interval.Start }}"
        AND calldate <= "{{ .Time.Interval.End }}"
        AND type = "LOCAL"
        AND (dst IN ({{ ExtractUserExtensions .CurrentUser }})) OR (src IN ({{ ExtractUserExtensions .CurrentUser }}))
