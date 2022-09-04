const namespaced = true;

const state = {
  notifications: [],
};

const getters = {
  notifications: (state) => state.notifications,
};

const actions = {
  async addNotification({ commit }, notification) {
    commit("addNotification", notification);
    setTimeout(() => {
      commit("removeNotification", notification.message);
    }, 5000);
  },
};

const mutations = {
  addNotification(state, notification) {
    state.notifications.push(notification);
  },
  removeNotification(state, message) {
    state.notifications = state.notifications.filter(
      (n) => n.message != message
    );
  },
};

export default {
  namespaced,
  state,
  getters,
  actions,
  mutations,
};
