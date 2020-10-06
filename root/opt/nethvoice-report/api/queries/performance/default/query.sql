SELECT p_a_d.period, 
       p_a_d.qname, 
       (SELECT count 
        FROM   performance_evase_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname) AS processed$tot, 
       (SELECT count 
        FROM   performance_good_year 
        WHERE  period = p_a_d.period 
               AND qname = p_a_d.qname) AS processed$60sec, 
       p_a_d.min_hold                   AS waiting$min, 
       p_a_d.max_hold                   AS waiting$max, 
       p_a_d.avg_hold                   AS waiting$avg, 
       p_a_d.min_duration               AS duration$min, 
       p_a_d.max_duration               AS duration$max, 
       p_a_d.avg_duration               AS duration$avg 
FROM   performance_attesa_durate_year p_a_d; 
