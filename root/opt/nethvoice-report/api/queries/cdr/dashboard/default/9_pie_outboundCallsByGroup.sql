SELECT
    cti_group,
    total AS total£num
FROM dashboard_cdr_9_{{ .Time.CdrDashboardRange }}
