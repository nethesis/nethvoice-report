SELECT
    inbound,
    total
FROM dashboard_cdr_1_{{ .Time.CdrDashboardRange }}
