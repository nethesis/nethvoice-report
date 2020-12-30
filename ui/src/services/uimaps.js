var UiMaps = {
  data() {
    return {
      filtersMap: {
        "queue": {
          "dashboard": {
            "default": ["time", "queue", "agent", "ivr", "choice"],
          },
          "data": {
            "summary": ["timeGroup", "time", "queue", "agent"],
            "agent": ["timeGroup", "time", "queue", "agent"],
            "session": ["time", "hour", "queue", "reason", "agent"],
            "caller": ["timeGroup", "time", "queue", "caller", "contactName"],
            "call": ["time", "hour", "queue", "caller", "contactName", "agent", "result"],
            "lost_call": ["timeGroup", "time", "queue", "caller", "contactName", "reason"],
            "ivr": ["timeGroup", "time", "ivr", "choice"]
          },
          "performance": {
            "default": ["timeGroup", "time", "queue"]
          },
          "distribution": {
            "hourly": ["timeGroup", "time", "queue", "timeSplit", "agent", "ivr"],
            "geographic": ["timeGroup", "time", "queue", "origin"],
          },
          "graphs": {
            "load": ["timeGroup", "time", "queue", "origin"],
            "hour": ["time", "queue", "agent", "destination", "ivr", "choice"],
            "agent": ["timeGroup", "time", "queue", "agent"],
            "area": ["timeGroup", "time", "queue"],
            "queue_position": ["time", "queue", "timeSplit"],
            "avg_duration": ["time", "queue", "timeSplit"],
            "avg_wait": ["time", "queue", "timeSplit"]
          }
        },
        "cdr": {
          "dashboard": {
            "default": ["cdr_fastTimeRange", "hour", "cdr_caller", "cdr_callee","cdr_did" , "cdr_callType", "cdr_callDuration", "cdr_trunk"],
          },
          "pbx": {
            "inbound": ["cdr_fastTimeRange", "hour", "cdr_caller", "cdr_callee","cdr_did", "cdr_callType", "cdr_callDuration", "cdr_trunk", "cdr_ctiGroups", "cdr_user", "cdr_callDestination"],
            "outbound": ["cdr_fastTimeRange", "hour", "cdr_caller", "cdr_callee","cdr_did", "cdr_callType", "cdr_callDuration", "cdr_trunk", "cdr_ctiGroups", "cdr_user", "cdr_destination"],
            "local": ["cdr_fastTimeRange", "hour", "cdr_caller", "cdr_callee","cdr_did", "cdr_callType", "cdr_callDuration", "cdr_user", "cdr_ctiGroups"],
          },
          "personal": {
            "inbound": ["cdr_fastTimeRange", "hour", "cdr_caller", "cdr_callee","cdr_did", "cdr_callType", "cdr_callDuration", "cdr_trunk", "cdr_callDestination"],
            "outbound": ["cdr_fastTimeRange", "hour", "cdr_caller", "cdr_callee","cdr_did", "cdr_callType", "cdr_callDuration", "cdr_trunk", "cdr_destination"],
            "local": ["cdr_fastTimeRange", "hour", "cdr_caller", "cdr_callee","cdr_did", "cdr_callType", "cdr_callDuration"],
          },
        }
      },
      groupByTimeValuesMap: [
        { value: "day", text: this.$i18n.t('filter.day') },
        { value: "week", text: this.$i18n.t('filter.week') },
        { value: "month", text: this.$i18n.t('filter.month') },
        { value: "year", text: this.$i18n.t('filter.year') },
      ],
      splitByTimeValuesMap: [
        { value: "60", text: "1 hour" },
        { value: "30", text: "30 minutes" },
        { value: "15", text: "15 minutes" },
        { value: "10", text: "10 minutes" },
      ],
      fastCdrTimeRangeValuesMap: [
        { value: "yesterday", text: this.$i18n.t('filter.yesterday') },
        { value: "last_two_days", text: this.$i18n.t('filter.last_two_days') },
        { value: "last_week", text: this.$i18n.t('filter.last_week') },
        { value: "last_month", text: this.$i18n.t('filter.last_month') },
        { value: "last_two_months", text: this.$i18n.t('filter.last_two_months') },
        { value: "last_three_months", text: this.$i18n.t('filter.last_three_months') },
        { value: "last_six_months", text: this.$i18n.t('filter.last_six_months') },
        { value: "last_year", text: this.$i18n.t('filter.last_year') },
        { value: "current_week", text: this.$i18n.t('filter.current_week') },
        { value: "past_week", text: this.$i18n.t('filter.past_week') },
        { value: "current_month", text: this.$i18n.t('filter.current_month') },
        { value: "past_month", text: this.$i18n.t('filter.past_month') },
        { value: "current_year", text: this.$i18n.t('filter.current_year') },
        { value: "past_year", text: this.$i18n.t('filter.past_year') },
      ],
      cdrCallDurationMap: [
        { value: "60", title: this.$i18n.t('filter.one_minute') },
        { value: "300", title: this.$i18n.t('filter.five_minutes') },
        { value: "900", title: this.$i18n.t('filter.fifteen_minutes') },
        { value: "1800", title: this.$i18n.t('filter.thirty_minutes') },
        { value: "3600", title: this.$i18n.t('filter.one_hour') },
        { value: "7200", title: this.$i18n.t('filter.two_hours') }
      ],
      cdrCallTypeMap: [
        { value: "answered", text: this.$i18n.t('filter.answered') },
        { value: "no_answer", text: this.$i18n.t('filter.no_answer') },
        { value: "busy", text: this.$i18n.t('filter.busy') },
        { value: "failed", text: this.$i18n.t('filter.failed') }
      ],
      callDestinationsMap: [
        { value: "dcontext,ext-group", text: this.$i18n.t('filter.call_groups') },
        { value: "lastapp,VoiceMail", text: this.$i18n.t('filter.voicemails') },
        { value: "lastapp,queue", text: this.$i18n.t('filter.queues') },
      ],
      calleeTypeMap: [
        { value: "mobile", text: this.$i18n.t('filter.mobile') },
        { value: "international", text: this.$i18n.t('filter.international') },
        { value: "fixed", text: this.$i18n.t('filter.fixed') },
      ]
    }
  }
}
export default UiMaps;
