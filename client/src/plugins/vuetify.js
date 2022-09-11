import Vue from "vue";
import Vuetify from "vuetify/lib/framework";

Vue.use(Vuetify);
export default new Vuetify({
  theme: {
    options: {
      customProperties: true,
    },
    themes: {
      light: {
        primary: "#030380",
      },
      dark: {
        primary: "#C7C7FF",
        info: "#2196F3",
        success: "#69FD81",
      },
    },
  },
});
