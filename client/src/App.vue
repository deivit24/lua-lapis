<template>
  <v-app id="app">
    <div>
      <v-system-bar window fixed>
        <div class="d-flex justify-center align-center">
          <v-btn small depressed color="transparent" @click="$router.push('/')">
            [<v-icon small>mdi-home</v-icon><span>ALL BOARDS</span>]</v-btn
          >
        </div>
        <div
          class="d-flex justify-center align-center"
          v-if="isAuth && authUser.role >= 8"
        >
          <v-btn
            @click="$router.push('/dashboard')"
            small
            depressed
            color="transparent"
          >
            [<v-icon small>mdi-dashboard</v-icon><span>DASHBOARD</span>]</v-btn
          >
        </div>
        <div
          class="d-flex justify-center align-center"
          v-if="notifications.length > 0"
          style="z-index: 1000"
        >
          [<v-icon :color="notifications[0].type" x-small>mdi-message</v-icon
          ><span :class="notifications[0].type + '--text'">{{
            notifications[0].message
          }}</span
          >]
        </div>
        <v-spacer></v-spacer>
        <div class="d-flex justify-center align-center" v-if="isAuth">
          <v-btn small text color="primary" @click="createBoardDialog = true">
            [<v-icon color="primary" small>mdi-clipboard-text-multiple</v-icon
            ><span>CREATE BOARD</span>]</v-btn
          >
        </div>
        <div class="d-flex justify-center align-center">
          <v-btn small depressed color="transparent" @click="toggleDarkMode">
            [<v-icon small>{{ modeIcon }}</v-icon
            ><span>{{ modeTitle }}</span
            >]</v-btn
          >
        </div>
        <div class="d-flex justify-center align-center" v-if="!isAuth">
          <v-btn
            id="login"
            small
            depressed
            color="transparent"
            @click="openLogin"
          >
            [<v-icon small>mdi-login</v-icon><span>LOGIN</span>]</v-btn
          >
        </div>
        <div class="d-flex justify-center align-center" v-if="isAuth">
          <v-btn
            id="logout"
            small
            depressed
            color="transparent"
            @click="logout"
          >
            [<v-icon small>mdi-logout</v-icon><span>LOGOUT</span>]</v-btn
          >
        </div>
        <auth-login
          :menu-model="menu"
          :position="postion"
          @close="menu = false"
        />
      </v-system-bar>
    </div>
    <board-create-dialog
      :create-dialog="createBoardDialog"
      @close="createBoardDialog = false"
    />
    <v-main class="mt-5">
      <router-view />
    </v-main>
  </v-app>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import AuthLogin from "./components/Auth/AuthLogin";
import BoardCreateDialog from "./components/Board/BoardCreateDialog";

export default {
  name: "App",
  components: {
    AuthLogin,
    BoardCreateDialog,
  },
  data: () => ({
    darkMode: true,
    menu: false,
    createBoardDialog: false,
    postion: { x: 0, y: 0 },
  }),
  created() {
    this.$vuetify.theme.dark = this.darkMode;
  },
  watch: {
    darkMode(val) {
      this.$vuetify.theme.dark = val;
    },
  },
  computed: {
    ...mapGetters({
      authUser: "auth/user",
      isAuth: "auth/isLoggedIn",
      notifications: "notifications/notifications",
    }),
    modeTitle() {
      if (this.darkMode) {
        return "LIGHT MODE";
      }
      return "DARK MODE";
    },
    modeIcon() {
      if (this.darkMode) return "mdi-weather-sunny";
      return "mdi-weather-night";
    },
  },
  methods: {
    ...mapActions({
      logoutUser: "auth/logoutUser",
      addNotification: "notifications/addNotification",
    }),
    toggleDarkMode() {
      this.darkMode = !this.darkMode;
      this.addNotification({
        message: `${this.modeTitle} ACTIVATED`,
        type: "primary",
      });
    },
    logout() {
      this.logoutUser();
      this.addNotification({
        message: `Successfully logged out`,
        type: "success",
      });
    },
    openLogin() {
      const el = document.getElementById("login");
      const rect = el.getBoundingClientRect();
      const postion = {
        x: rect.left + window.scrollX,
        y: rect.top + window.scrollY + 25,
      };
      this.postion = postion;
      this.menu = true;
    },
  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&display=swap");
#app {
  font-family: "Nanum Gothic Coding", monospace;
}
</style>
