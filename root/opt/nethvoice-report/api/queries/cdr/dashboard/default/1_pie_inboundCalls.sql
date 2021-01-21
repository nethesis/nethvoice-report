SELECT
    inbound,
    total AS total£num
FROM dashboard_cdr_1_{{ .Time.CdrDashboardRange }}
