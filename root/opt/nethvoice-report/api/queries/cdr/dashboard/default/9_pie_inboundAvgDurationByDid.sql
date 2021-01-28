SELECT
    did,
    avg_duration as avg_duration£seconds
FROM dashboard_cdr_9_{{ .Time.CdrDashboardRange }}
