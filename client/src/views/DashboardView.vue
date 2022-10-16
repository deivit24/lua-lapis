<template>
  <v-container>
    <h1 class="mt-5">Welcome back {{ authUser.username }}</h1>
    <p>Manage boards, announcements, users and bans from one page</p>
    <v-card flat>
      <v-tabs v-model="tab">
        <v-tab href="#boards"> Boards </v-tab>
        <v-tab href="#users"> Users </v-tab>
        <v-tab href="#bans"> Bans </v-tab>
        <v-tab href="#postReports"> Post Reports </v-tab>
        <v-tab href="#commentReports"> Comment Reports </v-tab>
      </v-tabs>

      <v-tabs-items v-model="tab">
        <v-tab-item value="boards">
          <v-card flat>
            <board-table />
          </v-card>
        </v-tab-item>
        <v-tab-item value="users">
          <v-card flat>
            <h1>USERS</h1>
          </v-card>
        </v-tab-item>
        <v-tab-item value="bans">
          <v-card flat>
            <h1>Bans</h1>
          </v-card>
        </v-tab-item>
        <v-tab-item value="postReports">
          <v-card flat>
            <board-reports-table />
          </v-card>
        </v-tab-item>
        <v-tab-item value="commentReports">
          <v-card flat>
            <board-comment-reports-table />
          </v-card>
        </v-tab-item>
      </v-tabs-items>
    </v-card>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import BoardCommentReportsTable from "../components/Board/BoardCommentReportsTable";
import BoardReportsTable from "../components/Board/BoardReportsTable";
import BoardTable from "../components/Board/BoardTable";
export default {
  name: "DashboardView",
  components: {
    BoardTable,
    BoardReportsTable,
    BoardCommentReportsTable,
  },
  data: () => ({
    tab: null,
  }),
  computed: {
    ...mapGetters({
      authUser: "auth/user",
      isAuth: "auth/isLoggedIn",
      notifications: "notifications/notifications",
    }),
  },
  created() {
    if (this.authUser.role < 8) this.$router.push("/");
  },
};
</script>

<style></style>
