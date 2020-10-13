import Vue from "vue";
import VueRouter from "vue-router";

/* Queue views */
import QueueView from "../views/QueueView.vue";

/* CDR views */
import CdrView from "../views/CdrView.vue";

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
      tags: ["dashboard"],
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
      tags: ["summary"],
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
      tags: ["performance"],
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
      tags: ["hourly"],
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
      tags: ["load"],
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
      tags: ["hour"],
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
      tags: ["agent"],
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
      tags: ["area"],
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
      tags: ["avg", "average", "wait"],
    },
  },

  /* CDR views*/
  {
    path: "/cdr",
    name: "CdrDashboard",
    component: CdrView,
    meta: {
      name: "menu.dashboard",
      parent: "",
      section: "dashboard",
      view: "default",
      tags: [],
    },
  },
];

const router = new VueRouter({
  routes,
});

export default router;
