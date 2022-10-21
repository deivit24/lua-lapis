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
          color="success"
          @click="viewPost(item.post_id)"
        >
          mdi-eye
        </v-icon>
      </template>
    </v-data-table>
    <v-dialog
      :key="dialog"
      v-model="dialog"
      max-width="500px"
      transition="dialog-transition"
    >
      <v-card flat>
        <v-card-title primary-title> Post </v-card-title>
        <v-card-text>
          <board-post-card :post="post" :is-preview="true" />
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn x-small text color="primary" @click="dialog = false">
            [ CANCEL ]
          </v-btn>
          <v-btn x-small text color="warning" @click="banPost(post.id)">
            [ BAN POST ]
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { BoardsApi } from "../../services/boards";
import { PostsAPI } from "../../services/posts";
import BoardPostCard from "./BoardPostCard";
import { mapActions } from "vuex";

export default {
  components: { BoardPostCard },
  name: "BoardReportsTable",
  data: () => ({
    reports: [],
    post: {},
    dialog: false,
    headers: [
      {
        text: "[ Post ID ]",
        value: "post_id",
        align: "center",
        width: "120px",
      },
      {
        text: "[ Name ]",
        align: "start",
        sortable: true,
        value: "name",
      },
      {
        text: "[ Subject ]",
        align: "start",
        sortable: true,
        value: "subject",
      },
      {
        text: "[ IP Address ]",
        align: "start",
        sortable: true,
        value: "ip",
      },
      {
        text: "[ # Reports ]",
        align: "center",
        sortable: true,
        value: "count",
      },
      {
        text: "",
        value: "actions",
        align: "end",
        sortable: false,
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
      const res = await BoardsApi.getAllReports(false, false);
      this.reports = res.reports;
    },
    async viewPost(id) {
      const res = await PostsAPI.getPost(id);
      this.post = res.post;
      this.dialog = true;
    },
    async banPost(id) {
      try {
        const data = {
          banned: true,
        };
        await PostsAPI.banPost(id, data);
        this.dialog = false;
        this.addNotification({
          message: "Post successfully banned",
          type: "success",
        });
      } catch (error) {
        console.error(error);
      }
    },
  },
};
</script>

<style></style>
