import Vue from "vue";
import VueRouter from "vue-router";

/* Queue views */
import QueueDashboard from "../views/queue/Dashboard.vue";

import QueueDataAgent from "../views/queue/DataAgent.vue";
import QueueDataSession from "../views/queue/DataSession.vue";
import QueueDataCaller from "../views/queue/DataCaller.vue";
import QueueDataCall from "../views/queue/DataCall.vue";
import QueueDataIVR from "../views/queue/DataIVR.vue";

import QueuePerformance from "../views/queue/Performance.vue";

import QueueDistributionHour from "../views/queue/DistributionHour.vue";
import QueueDistributionGeo from "../views/queue/DistributionGeo.vue";

import QueueGraphsLoad from "../views/queue/GraphsLoad.vue";
import QueueGraphsHour from "../views/queue/GraphsHour.vue";
import QueueGraphsAgent from "../views/queue/GraphsAgent.vue";
import QueueGraphsArea from "../views/queue/GraphsArea.vue";
import QueueGraphsQueuePosition from "../views/queue/GraphsQueuePosition.vue";
import QueueGraphsAvgDuration from "../views/queue/GraphsAvgDuration.vue";
import QueueGraphsAvgWait from "../views/queue/GraphsAvgWait.vue";

/* CDR views */
import CDRDashboard from "../views/cdr/Dashboard.vue";

Vue.use(VueRouter);

const routes = [
  /* Queue views*/
  {
    path: "/queue",
    name: "QueueDashboard",
    component: QueueDashboard,
    meta: {
      name: "menu.dashboard",
      parent: "",
      tags: ["dashboard"],
    },
  },
  {
    path: "/queue/data/agent",
    name: "QueueDataAgent",
    component: QueueDataAgent,
    meta: {
      name: "data.by_agent",
      parent: "data",
      tags: ["agent"],
    },
  },
  {
    path: "/queue/data/session",
    name: "QueueDataSession",
    component: QueueDataSession,
    meta: {
      name: "data.by_session",
      parent: "data",
      tags: ["session"],
    },
  },
  {
    path: "/queue/data/caller",
    name: "QueueDataCaller",
    component: QueueDataCaller,
    meta: {
      name: "data.by_caller",
      parent: "data",
      tags: ["caller"],
    },
  },
  {
    path: "/queue/data/call",
    name: "QueueDataCall",
    component: QueueDataCall,
    meta: {
      name: "data.by_call",
      parent: "data",
      tags: ["call"],
    },
  },
  {
    path: "/queue/data/ivr",
    name: "QueueDataIVR",
    component: QueueDataIVR,
    meta: {
      name: "data.ivr",
      parent: "data",
      tags: ["ivr"],
    },
  },
  {
    path: "/queue/performance",
    name: "QueuePerformance",
    component: QueuePerformance,
    meta: {
      name: "menu.performance",
      parent: "performance",
      tags: ["performance"],
    },
  },
  {
    path: "/queue/distribution/hour",
    name: "QueueDistributionHour",
    component: QueueDistributionHour,
    meta: {
      name: "distribution.by_hour",
      parent: "distribution",
      tags: ["hour"],
    },
  },
  {
    path: "/queue/distribution/geo",
    name: "QueueDistributionGeo",
    component: QueueDistributionGeo,
    meta: {
      name: "distribution.by_geo",
      parent: "distribution",
      tags: ["geo"],
    },
  },
  {
    path: "/queue/graphs/load",
    name: "QueueGraphsLoad",
    component: QueueGraphsLoad,
    meta: {
      name: "graphs.load",
      parent: "graphs",
      tags: ["load"],
    },
  },
  {
    path: "/queue/graphs/hour",
    name: "QueueGraphsHour",
    component: QueueGraphsHour,
    meta: {
      name: "graphs.by_hour",
      parent: "graphs",
      tags: ["hour"],
    },
  },
  {
    path: "/queue/graphs/agent",
    name: "QueueGraphsAgent",
    component: QueueGraphsAgent,
    meta: {
      name: "graphs.by_agent",
      parent: "graphs",
      tags: ["agent"],
    },
  },
  {
    path: "/queue/graphs/area",
    name: "QueueGraphsArea",
    component: QueueGraphsArea,
    meta: {
      name: "graphs.by_area",
      parent: "graphs",
      tags: ["area"],
    },
  },
  {
    path: "/queue/graphs/queue_position",
    name: "QueueGraphsQueuePosition",
    component: QueueGraphsQueuePosition,
    meta: {
      name: "graphs.queue_position",
      parent: "graphs",
      tags: ["queue", "position"],
    },
  },
  {
    path: "/queue/graphs/avg_duration",
    name: "QueueGraphsAvgDuration",
    component: QueueGraphsAvgDuration,
    meta: {
      name: "graphs.average_duration",
      parent: "graphs",
      tags: ["avg", "average", "duration"],
    },
  },
  {
    path: "/queue/graphs/avg_wait",
    name: "QueueGraphsAvgWait",
    component: QueueGraphsAvgWait,
    meta: {
      name: "graphs.average_wait",
      parent: "graphs",
      tags: ["avg", "average", "wait"],
    },
  },

  /* CDR views*/
  {
    path: "/cdr",
    name: "CDRDashboard",
    component: CDRDashboard,
    meta: {
      name: "menu.cdr",
      parent: "",
      tags: [],
    },
  },
];

const router = new VueRouter({
  routes,
});

export default router;
