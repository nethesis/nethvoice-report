SELECT
    inbound,
    avg_wait as avgHold£seconds
FROM dashboard_cdr_3_{{ .Time.CdrDashboardRange }}
