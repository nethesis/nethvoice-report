UPDATE `{{ .Table }}`
SET    cost = billsec * (SELECT cost / 60
                         FROM   cost_details
                         WHERE  destination = call_type
				AND channelid = Substring_index(SUBSTRING(dstchannel,1,LENGTH(dstchannel)-LOCATE('-',REVERSE(dstchannel))), '/', -1)
			)
WHERE  cost IS NULL AND type = "OUT";
