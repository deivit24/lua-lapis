<template>
  <v-app id="app">
    <div>
      <v-system-bar window dark fixed>
        <div class="d-flex justify-center align-center">
          [<v-icon small>mdi-home</v-icon><span>ALL BOARDS</span>]
        </div>
        <v-spacer></v-spacer>
        <div class="d-flex justify-center align-center mr-2">
          [<v-icon small>mdi-theme-light-dark</v-icon><span>LIGHT MODE</span>]
        </div>
        <div class="d-flex justify-center align-center">
          [<v-icon small>mdi-login</v-icon><span>LOGIN</span>]
        </div>
      </v-system-bar>
    </div>
    <v-main class="mt-5">
      <router-view />
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: "App",
  data: () => ({
    //
  }),
  created() {
    this.$vuetify.theme.isDark = true;
  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding:wght@400;700&display=swap");
#app {
  font-family: "Nanum Gothic Coding", monospace;
}
</style>
