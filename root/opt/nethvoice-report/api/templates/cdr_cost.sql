UPDATE `{{ .Table }}`
SET    cost = billsec * (SELECT cost
                         FROM   cost_details
                         WHERE  destination = call_type 
                                AND channelid = Substring_index(Substring_index( 
                                                            dstchannel, 
                                                            '-', 1 
                                                            ), '/', -1 
                                            )) 
WHERE  cost IS NULL AND type = "OUT"; 
