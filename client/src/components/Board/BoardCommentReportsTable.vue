<template>
  <div>
    <v-data-table
      :headers="headers"
      :items="reports"
      :items-per-page="5"
      class="elevation-1"
    >
      <template v-slot:[`item.actions`]="{ item }">
        <v-icon
          small
          class="mr-2"
          color="error"
          @click="banComment(item.comment_id)"
        >
          mdi-delete
        </v-icon>
      </template>
      <template v-slot:[`item.body`]="{ item }">
        <span v-html="item.body"></span>
      </template>
    </v-data-table>
  </div>
</template>

<script>
import { BoardsApi } from "../../services/boards";
// import { PostsAPI } from "../../services/posts";
import { mapActions } from "vuex";

export default {
  name: "BoardCommentReportsTable",
  data: () => ({
    reports: [],
    headers: [
      {
        text: "[ name ]",
        value: "name",
        align: "start",
      },
      {
        text: "[ Body ]",
        align: "start",
        sortable: true,
        value: "body",
      },
      {
        text: "[ IP Address ]",
        align: "start",
        sortable: true,
        value: "ip",
        width: "120px",
      },
      {
        text: "[ # Reports ]",
        align: "center",
        sortable: true,
        value: "count",
        width: "120px",
      },
      {
        text: "",
        value: "actions",
        align: "end",
        sortable: false,
        width: "120px",
      },
    ],
  }),
  created() {
    this.getReports();
  },
  methods: {
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
    async getReports() {
      const res = await BoardsApi.getAllReports(false, true);
      console.log(res);
      this.reports = res.reports;
    },
    async banComment(id) {
      console.log(id);
      // Create a ban comment api in the backend for now we are goign to just console.log the fucking id
      // try {
      //   const data = {

      //     banned: true,
      //   };
      //   await PostsAPI.banPost(id, data);
      //   this.dialog = false;
      //   this.addNotification({
      //     message: "Post successfully banned",
      //     type: "success",
      //   });
      // } catch (error) {
      //   console.error(error);
      // }
    },
  },
};
</script>

<style></style>
