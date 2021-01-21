SELECT
    inbound,
    month AS month£month,
    total AS total£num
FROM dashboard_cdr_5_{{ .Time.CdrDashboardRange }}
