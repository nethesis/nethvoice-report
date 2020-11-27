import Vue from "vue";
import VueRouter from "vue-router";

/* Queue views */
import QueueView from "../views/QueueView.vue";

Vue.use(VueRouter);

const routes = [
  { path: "/", redirect: "/queue" },

  /* Queue views*/
  {
    path: "/queue",
    name: "QueueDashboard",
    component: QueueView,
    meta: {
      name: "menu.dashboard",
      parent: "",
      section: "dashboard",
      view: "default",
      report: "queue",
      tags: ["dashboard", "calls", "agent", "hour", "answer", "lost", "done", "ivr", "choices", "unique", "caller", "total"],
    },
  },
  {
    path: "/queue/data/summary",
    name: "QueueDataSummary",
    component: QueueView,
    meta: {
      name: "data.summary",
      parent: "data",
      section: "data",
      view: "summary",
      report: "queue",
      tags: ["summary", "good", "failed", "timeout", "exitempty", "exitkey", "full", "joinempty", "null", "agent"],
    },
  },
  {
    path: "/queue/data/agent",
    name: "QueueDataAgent",
    component: QueueView,
    meta: {
      name: "data.by_agent",
      parent: "data",
      section: "data",
      view: "agent",
      report: "queue",
      tags: ["agent"],
    },
  },
  {
    path: "/queue/data/session",
    name: "QueueDataSession",
    component: QueueView,
    meta: {
      name: "data.by_session",
      parent: "data",
      section: "data",
      view: "session",
      report: "queue",
      tags: ["session"],
    },
  },
  {
    path: "/queue/data/caller",
    name: "QueueDataCaller",
    component: QueueView,
    meta: {
      name: "data.by_caller",
      parent: "data",
      section: "data",
      view: "caller",
      report: "queue",
      tags: ["caller"],
    },
  },
  {
    path: "/queue/data/call",
    name: "QueueDataCall",
    component: QueueView,
    meta: {
      name: "data.by_call",
      parent: "data",
      section: "data",
      view: "call",
      report: "queue",
      tags: ["call"],
    },
  },
  {
    path: "/queue/data/lost_call",
    name: "QueueDataLostCall",
    component: QueueView,
    meta: {
      name: "data.by_lost_call",
      parent: "data",
      section: "data",
      view: "lost_call",
      report: "queue",
      tags: ["lost call"],
    },
  },
  {
    path: "/queue/data/ivr",
    name: "QueueDataIVR",
    component: QueueView,
    meta: {
      name: "data.ivr",
      parent: "data",
      section: "data",
      view: "ivr",
      report: "queue",
      tags: ["ivr"],
    },
  },
  {
    path: "/queue/performance",
    name: "QueuePerformance",
    component: QueueView,
    meta: {
      name: "menu.performance",
      parent: "performance",
      section: "performance",
      view: "default",
      report: "queue",
      tags: ["performance", "qos", "quality", "talk time", "time"],
    },
  },
  {
    path: "/queue/distribution/hour",
    name: "QueueDistributionHour",
    component: QueueView,
    meta: {
      name: "distribution.by_hour",
      parent: "distribution",
      section: "distribution",
      view: "hourly",
      report: "queue",
      tags: ["hourly", "good", "failed", "timeout", "exitempty", "exitkey", "full", "joinempty", "null", "agent", "ivr"],
    },
  },
  {
    path: "/queue/distribution/geo",
    name: "QueueDistributionGeo",
    component: QueueView,
    meta: {
      name: "distribution.by_geo",
      parent: "distribution",
      section: "distribution",
      view: "geographic",
      report: "queue",
      tags: ["geographic"],
    },
  },
  {
    path: "/queue/graphs/load",
    name: "QueueGraphsLoad",
    component: QueueView,
    meta: {
      name: "graphs.load",
      parent: "graphs",
      section: "graphs",
      view: "load",
      report: "queue",
      tags: ["load", "geographic"],
    },
  },
  {
    path: "/queue/graphs/hour",
    name: "QueueGraphsHour",
    component: QueueView,
    meta: {
      name: "graphs.by_hour",
      parent: "graphs",
      section: "graphs",
      view: "hour",
      report: "queue",
      tags: ["hour", "good", "failed", "timeout", "exitempty", "exitkey", "full", "joinempty", "null", "agent", "ivr"],
    },
  },
  {
    path: "/queue/graphs/agent",
    name: "QueueGraphsAgent",
    component: QueueView,
    meta: {
      name: "graphs.by_agent",
      parent: "graphs",
      section: "graphs",
      view: "agent",
      report: "queue",
      tags: ["agent", "answer", "no answer", "lost", "done", "queue"],
    },
  },
  {
    path: "/queue/graphs/area",
    name: "QueueGraphsArea",
    component: QueueView,
    meta: {
      name: "graphs.by_area",
      parent: "graphs",
      section: "graphs",
      view: "area",
      report: "queue",
      tags: ["area", "district", "area code", "province", "region"],
    },
  },
  {
    path: "/queue/graphs/queue_position",
    name: "QueueGraphsQueuePosition",
    component: QueueView,
    meta: {
      name: "graphs.queue_position",
      parent: "graphs",
      section: "graphs",
      view: "queue_position",
      report: "queue",
      tags: ["queue", "position"],
    },
  },
  {
    path: "/queue/graphs/avg_duration",
    name: "QueueGraphsAvgDuration",
    component: QueueView,
    meta: {
      name: "graphs.average_duration",
      parent: "graphs",
      section: "graphs",
      view: "avg_duration",
      report: "queue",
      tags: ["avg", "average", "duration"],
    },
  },
  {
    path: "/queue/graphs/avg_wait",
    name: "QueueGraphsAvgWait",
    component: QueueView,
    meta: {
      name: "graphs.average_wait",
      parent: "graphs",
      section: "graphs",
      view: "avg_wait",
      report: "queue",
      tags: ["avg", "average", "wait"],
    },
  },

  /* CDR views*/
  {
    path: "/cdr",
    name: "CdrDashboard",
    component: QueueView,
    meta: {
      name: "menu.dashboard",
      parent: "",
      section: "dashboard",
      view: "default",
      report: "cdr",
      tags: ["dashboard"],
    },
  },
  {
    path: "/cdr/pbx/incoming_calls",
    name: "PbxDataIncoming",
    component: QueueView,
    meta: {
      name: "menu.incoming_calls",
      parent: "pbx_data",
      section: "pbx_data",
      view: "incoming_calls",
      report: "cdr",
      tags: ["pbx", "incoming"],
    },
  },
  {
    path: "/cdr/pbx/outgoing_calls",
    name: "PbxDataOutgoing",
    component: QueueView,
    meta: {
      name: "menu.outgoing_calls",
      parent: "pbx_data",
      section: "pbx_data",
      view: "outgoing_calls",
      report: "cdr",
      tags: ["pbx", "outgoing"],
    },
  },
  {
    path: "/cdr/pbx/internal_calls",
    name: "PbxDataInternal",
    component: QueueView,
    meta: {
      name: "menu.internal_calls",
      parent: "pbx_data",
      section: "pbx_data",
      view: "internal_calls",
      report: "cdr",
      tags: ["pbx", "internal"],
    }
  },
  {
    path: "/cdr/personal/incoming_calls",
    name: "PersonalDataIncoming",
    component: QueueView,
    meta: {
      name: "menu.incoming_calls",
      parent: "personal_data",
      section: "personal_data",
      view: "incoming_calls",
      report: "cdr",
      tags: ["personal", "incoming"],
    }
  },
  {
    path: "/cdr/personal/outgoing_calls",
    name: "PersonalDataOutgoing",
    component: QueueView,
    meta: {
      name: "menu.outgoing_calls",
      parent: "personal_data",
      section: "personal_data",
      view: "outgoing_calls",
      report: "cdr",
      tags: ["personal", "outgoing"],
    }
  },
  {
    path: "/cdr/personal/internal_calls",
    name: "PersonalDataInternal",
    component: QueueView,
    meta: {
      name: "menu.internal_calls",
      parent: "personal_data",
      section: "personal_data",
      view: "internal_calls",
      report: "cdr",
      tags: ["personal", "internal"],
    }
  }
];

const router = new VueRouter({
  routes,
});

export default router;
