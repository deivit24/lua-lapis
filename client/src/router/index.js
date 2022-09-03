import Vue from "vue";
import VueRouter from "vue-router";
import BoardsView from "../views/BoardsView.vue";
import BoardsDetails from "../views/BoardsDetails.vue";

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
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
