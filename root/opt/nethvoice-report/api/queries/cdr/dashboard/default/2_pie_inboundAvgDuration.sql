SELECT
    inbound,
    avg_duration as avg_duration£seconds
FROM dashboard_cdr_2_{{ .Time.CdrDashboardRange }}
