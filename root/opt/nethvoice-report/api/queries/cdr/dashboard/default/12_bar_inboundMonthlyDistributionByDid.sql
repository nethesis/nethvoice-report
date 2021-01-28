SELECT
    did,
    month AS month£month,
    total AS total£num
FROM dashboard_cdr_12_{{ .Time.CdrDashboardRange }}
