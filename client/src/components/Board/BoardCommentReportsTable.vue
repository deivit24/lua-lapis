<template>
  <div>
    <v-data-table
      :headers="headers"
      :items="reports"
      :items-per-page="5"
      class="elevation-1"
    >
      <template v-slot:[`item.actions`]="{ item }">
        <v-icon small class="mr-2" color="info" @click="viewReport(item.id)">
          mdi-card-search
        </v-icon>
        <v-icon
          small
          class="mr-2"
          color="error"
          @click="banComment(item.comment_id)"
        >
          mdi-delete
        </v-icon>
      </template>
      <template v-slot:[`item.created_at`]="{ item }">
        <span v-html="formatDate(item.created_at)"></span>
      </template>
    </v-data-table>
    <v-dialog v-if="selectedReport" v-model="dialog" :width="500" persistant>
      <v-card flat>
        <v-card-title
          >Reported:
          <span class="ml-2 error--text">
            {{ selectedReport.report_type }}
          </span></v-card-title
        >
        <v-card-text>
          <h3 class="mb-2">
            Comment by <span class="info--text">{{ selectedReport.name }}</span>
          </h3>
          <div v-html="selectedReport.body"></div>
          <h3 class="mb-2">Reason</h3>
          <div v-html="selectedReport.report"></div>
        </v-card-text>
        <v-card-actions>
          <v-btn
            text
            color="error"
            @click="
              dialog = false;
              selectedReport = null;
            "
          >
            [ Cancel ]
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { BoardsApi } from "../../services/boards";
import moment from "moment";
// import { PostsAPI } from "../../services/posts";
import { mapActions } from "vuex";

export default {
  name: "BoardCommentReportsTable",
  data: () => ({
    dialog: false,
    reports: [],
    headers: [
      {
        text: "[ Name ]",
        value: "name",
        align: "start",
      },
      {
        text: "[ Type ]",
        value: "report_type",
        align: "start",
      },
      {
        text: "[ IP Address ]",
        align: "start",
        sortable: true,
        value: "ip",
        width: "140px",
      },
      {
        text: "[ Created ]",
        align: "center",
        sortable: true,
        value: "created_at",
      },
      {
        text: "",
        value: "actions",
        align: "end",
        sortable: false,
        width: "120px",
      },
    ],
    selectedReport: null,
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
      this.reports = res.reports;
    },
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
    viewReport(report_id) {
      const found = this.reports.find((r) => r.id === report_id);
      this.selectedReport = found;
      this.dialog = true;
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
