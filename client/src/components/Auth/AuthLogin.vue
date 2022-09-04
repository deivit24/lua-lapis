<template>
  <div class="text-center">
    <v-menu
      v-model="menu"
      :close-on-content-click="false"
      :close-on-click="false"
      :nudge-width="300"
      offset-y
      :position-x="position.x"
      :position-y="position.y"
    >
      <v-card>
        <v-card-title primary-title> [ LOGIN ] </v-card-title>
        <v-card-text>
          <v-form ref="form" v-model="valid" lazy-validation>
            <v-text-field
              v-model="username"
              placeholder="Username"
              :rules="[rules.required]"
              :loading="loading"
              flat
            ></v-text-field>
            <v-text-field
              v-model="password"
              :rules="[rules.required]"
              placeholder="Password"
              type="password"
              :loading="loading"
              flat
            ></v-text-field>
            <span v-if="errorMessage" class="error--text"
              >[{{ errorMessage }}]</span
            >
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>

          <v-btn text color="error" @click="close"> [ Cancel ] </v-btn>
          <v-btn
            :color="$vuetify.theme.isDark ? '#E3E3F9' : 'primary'"
            :loading="loading"
            :disabled="!valid"
            text
            @click="login"
          >
            [ Save ]
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-menu>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
export default {
  name: "AuthLogin",
  props: {
    menuModel: {
      type: Boolean,
      default: false,
    },
    position: {
      type: Object,
      required: true,
    },
  },
  data: () => ({
    menu: false,
    valid: false,
    username: "",
    password: "",
    loading: false,
    errorMessage: "",
    rules: {
      required: (value) => !!value || "Required.",
    },
  }),
  watch: {
    menuModel(val) {
      this.menu = val;
    },
  },
  computed: {
    ...mapGetters({
      authUser: "auth/user",
      isAuth: "auth/isLoggedIn",
    }),
  },
  methods: {
    ...mapActions({
      loginUser: "auth/loginUser",
      setUser: "auth/setUser",
      logoutUser: "auth/logoutUser",
      addNotification: "notifications/addNotification",
    }),
    async login() {
      try {
        this.loading = true;
        this.errorMessage = "";
        const data = {
          username: this.username,
          password: this.password,
        };
        const res = await this.loginUser(data);
        this.setUser(res);
        this.addNotification({
          message: `Welcome back ${this.authUser.username}`,
          type: "primary",
        });
        this.close();
      } catch (error) {
        this.logoutUser();
        this.errorMessage = error.response.data[0].message;
      } finally {
        this.loading = false;
      }
    },
    close() {
      this.$emit("close");
      this.username = "";
      this.password = "";
      this.errorMessage = "";
    },
  },
};
</script>
