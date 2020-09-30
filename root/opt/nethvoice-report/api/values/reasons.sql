SELECT DISTINCT reason FROM agentsessions WHERE reason NOT LIKE 'Local/%@from-queue/n' AND reason NOT LIKE '';
