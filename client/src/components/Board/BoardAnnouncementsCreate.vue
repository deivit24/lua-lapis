<template>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-card-title primary-title> [ Create Announcement ] </v-card-title>
      <v-card-text>
        <v-row no-gutters class="text-left pa-2">
          <v-col cols="12">
            <v-select
              return-object
              v-model="announcement"
              :items="types"
              item-text="name"
              item-value="type"
              label="Announcement Type"
              class="mx-2"
              hide-details
            ></v-select>
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="body"
              label="Message"
              placeholder="No more dick pics"
              counter
              maxlength="50"
              class="mx-2"
            ></v-text-field>
          </v-col>
        </v-row>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn x-small text color="error" @click="$emit('close')">
          [ CANCEL]
        </v-btn>
        <v-btn x-small text color="primary" @click="createAnnouncement">
          [ CREATE]
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { AnnouncementsApi } from "../../services/announcements";
import { mapActions } from "vuex";
export default {
  name: "BoardAnnouncemnentsCreate",
  data: () => ({
    dialog: false,
    body: "",
    types: [
      {
        name: "Good News",
        type: 1,
      },
      {
        name: "Informative",
        type: 2,
      },
      {
        name: "Warning",
        type: 3,
      },
      {
        name: "Critical",
        type: 4,
      },
    ],
    announcement: null,
  }),
  props: {
    createDialog: {
      type: Boolean,
    },
    boardId: {
      type: Number,
    },
  },
  watch: {
    createDialog(val) {
      this.dialog = val;
    },
  },
  methods: {
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
    async createAnnouncement() {
      try {
        const data = this.createData();
        const res = await AnnouncementsApi.createAnnouncement(data);
        this.$emit("add", res.announcement);
        this.$emit("close");
        this.addNotification({
          message: "Announcement Successfully Added",
          type: "success",
        });
        this.reset();
      } catch (error) {
        this.addNotification({
          message: error.response.data[0].message,
          type: "error",
        });
      }
    },
    reset() {
      this.category = null;
      this.body = "";
    },
    createData() {
      return {
        text: this.body,
        type: this.announcement.type,
        board_id: this.boardId,
      };
    },
  },
};
</script>

<style></style>
