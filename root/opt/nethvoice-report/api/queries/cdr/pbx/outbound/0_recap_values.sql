SELECT Count(*)                                                 AS "total£num", 
       Sum(IF(dispositions REGEXP 'ANSWERED$', 1, 0))           AS "answered£num", 
       Sum(IF(dispositions REGEXP 'NO ANSWER$', 1, 0))          AS "noAnswer£num", 
       Sum(IF(dispositions REGEXP 'BUSY$', 1, 0))               AS "busy£num", 
       Sum(IF(( dispositions REGEXP 'FAILED$' 
                 OR dispositions REGEXP 'CONGESTION$' ), 1, 0)) AS "failed£num",
       Sum(duration)						AS "totalDuration£seconds",	
       Avg(duration)                                            AS "avgDuration£seconds",
       Sum(cost)						AS "totalCost£currency",
       Avg(cost)                                                AS "avgCost£currency", 
       Sum(duration) - Sum(billsec)				AS "totalWait£seconds",
       Avg(duration) - Avg(billsec)                             AS "avgWait£seconds" 
FROM   `<CDR_TABLE>`; 
