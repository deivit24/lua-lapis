const namespaced = true;

const state = {
  reload: false,
};

const getters = {
  reload: (state) => state.reload,
};

const actions = {
  async reloadBoards({ commit }) {
    commit("reloadBoards");
    setTimeout(() => {
      commit("setReloadFalse", false);
    }, 5000);
  },
};

const mutations = {
  reloadBoards(state) {
    state.reload = true;
  },
  setReloadFalse(state) {
    state.reload = false;
  },
};

export default {
  namespaced,
  state,
  getters,
  actions,
  mutations,
};
