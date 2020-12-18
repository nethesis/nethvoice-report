SELECT
	linkedid,
    src AS src£phoneNumber,
    dst AS dst£phoneNumber,
    type AS call_type£label,
    DATE_FORMAT(calldate, '%Y-%m-%d %H:%i:%s') AS time,
    SUBSTRING_INDEX(dispositions, ',',- 1) AS result£label, -- get last disposition
    billsec,
    cost
    -- //// clid, dcontext, channel, dstchannel, lastapp, lastdata, duration, disposition, amaflags, accountcode, uniqueid, userfield, did, recordingfile, cnum, cnam, outbound_cnum, outbound_cnam, dst_cnam, peeraccount, sequence, ccompany, dst_ccompany, lastapps, dcontexts, call_type
FROM	`<CDR_TABLE>`
WHERE	calldate >= "{{ .Time.Interval.Start }}"
	AND calldate <= "{{ .Time.Interval.End }}"
	AND type = "LOCAL"
	{{ if (and (gt (len .Sources) 0) (gt (len .Destinations) 0)) }}
          AND (src IN ({{ ExtractStrings .Sources }}) OR dst IN ({{ ExtractStrings .Destinations }}))
        {{ else if gt (len .Sources) 0 }}
          AND src IN ({{ ExtractStrings .Sources }})
        {{ else if gt (len .Destinations) 0 }}
          AND dst IN ({{ ExtractStrings .Destinations }})
        {{ else }}
        {{ end }}
	{{ if .CallType }}
	  AND dispositions REGEXP "{{ .CallType }}$"
	{{ end }}
	{{ if .Duration }}
	  AND duration <= {{ .Duration }}
	{{ end }}
	{{ if gt (len .Trunks) 0 }}
	  AND channel LIKE "%{{ .Trunks }}%"
	{{ end }}
