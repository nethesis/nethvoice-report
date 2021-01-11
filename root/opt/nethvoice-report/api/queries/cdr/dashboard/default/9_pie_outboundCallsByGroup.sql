SELECT
    cti_group,
    total
FROM dashboard_cdr_9_{{ .Time.CdrDashboardRange }}
