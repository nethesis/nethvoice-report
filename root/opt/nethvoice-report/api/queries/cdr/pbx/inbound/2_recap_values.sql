SELECT Count(*)                                                 AS total, 
       Sum(IF(dispositions REGEXP 'ANSWERED$', 1, 0))           AS "answered", 
       Sum(IF(dispositions REGEXP 'NO ANSWER$', 1, 0))          AS "no answer", 
       Sum(IF(dispositions REGEXP 'BUSY$', 1, 0))               AS "busy", 
       Sum(IF(( dispositions REGEXP 'FAILED$' 
                 OR dispositions REGEXP 'CONGESTION$' ), 1, 0)) AS "failed", 
       Avg(duration)                                            AS duration, 
       Avg(cost)                                                AS cost, 
       Avg(duration) - Avg(billsec)                             AS wait 
FROM   `cdr_2020-03`; 
