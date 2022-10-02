const namespaced = true;

const state = {
  dialog: false,
  closeText: "Close",
  title: "Default Title",
};

const getters = {
  dialog: (state) => state.dialog,
  closeText: (state) => state.closeText,
  title: (state) => state.title,
};

const actions = {
  setDialog({ commit }, data) {
    commit("setDialog", data);
  },
  closeDialog({ commit }) {
    commit("close");
  },
};

const mutations = {
  setDialog(state, data) {
    state.dialog = data.dialog;
    state.closeText = data.closeText;
    state.title = data.title;
  },
  close(state) {
    state.dialog = false;
    state.closeText = "Close";
    state.title = "Default Title";
  },
};

export default {
  namespaced,
  state,
  getters,
  actions,
  mutations,
};
