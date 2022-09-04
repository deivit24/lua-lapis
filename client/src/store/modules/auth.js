import { AuthApi } from "@/services/auth";
const namespaced = true;
const user = JSON.parse(localStorage.getItem("pluv")) || null;
const state = {
  user: user,
  isLoggedIn: user ? true : false,
};

const getters = {
  isLoggedIn: (state) => state.isLoggedIn,
  user: (state) => state.user,
};

const actions = {
  // eslint-disable-next-line
  async loginUser({}, data) {
    return await AuthApi.login(data);
  },
  async logoutUser({ commit }) {
    localStorage.removeItem("pluv");
    commit("logoutUserState");
  },
  async setUser({ commit }, user) {
    localStorage.setItem("pluv", JSON.stringify(user));
    commit("setUser", user);
  },
};

const mutations = {
  setUser(state, user) {
    state.isLoggedIn = true;
    state.user = user;
  },
  logoutUserState(state) {
    state.isLoggedIn = false;
    state.user = null;
  },
};

export default {
  namespaced,
  state,
  getters,
  actions,
  mutations,
};
