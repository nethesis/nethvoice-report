SELECT  *
FROM    `<CDR_TABLE>`
WHERE   calldate >= "{{ .Time.Interval.Start }}"
        AND calldate <= "{{ .Time.Interval.End }}"
        AND type = "IN"
	AND dst IN ({{ ExtractUserExtensions .CurrentUser }})
