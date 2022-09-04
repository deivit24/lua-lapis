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
        secondary: "#004D40",
        accent: "#4A148C",
        error: "#FFA8A8",
        warning: "#BF360C",
        info: "#E3E3F9",
        success: "#69FD81",
      },
    },
  },
});
