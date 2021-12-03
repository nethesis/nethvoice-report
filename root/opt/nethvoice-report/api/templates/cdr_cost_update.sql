UPDATE `{{ .Table }}`
SET    	cost = billsec * {{ .Cost }} / 60
WHERE  	type = "OUT"
	AND call_type = "{{ .Destination }}"
	AND Substring_index(SUBSTRING(dstchannel,1,LENGTH(dstchannel)-LOCATE('-',REVERSE(dstchannel))), '/', -1) = "{{ .Trunk }}"
