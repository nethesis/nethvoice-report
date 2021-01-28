SELECT
    did,
    avg_wait as avgHold£seconds
FROM dashboard_cdr_10_{{ .Time.CdrDashboardRange }}
