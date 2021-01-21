SELECT
    province,
    total AS total£num
FROM dashboard_cdr_13_{{ .Time.CdrDashboardRange }}
