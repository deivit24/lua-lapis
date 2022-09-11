import Vue from "vue";
import VueRouter from "vue-router";
import BoardsView from "../views/BoardsView.vue";
import BoardsDetails from "../views/BoardsDetails.vue";
import DashboardView from "../views/DashboardView";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "boards",
    component: BoardsView,
  },
  {
    path: "/boards/:id",
    name: "board",
    component: BoardsDetails,
  },
  {
    path: "/dashboard",
    name: "dashboard",
    component: DashboardView,
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

router.beforeEach((to, from, next) => {
  const publicPages = ["boards", "board"];
  const authRequired = !publicPages.includes(to.name);
  const loggedIn = localStorage.getItem("pluv");
  // trying to access a restricted page + not logged in
  // redirect to login page
  if (authRequired && !loggedIn) {
    next("/");
  } else {
    next();
  }
});

export default router;
