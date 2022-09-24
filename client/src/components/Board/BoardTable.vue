<template>
  <div>
    <v-data-table
      :headers="headers"
      :items="boards"
      :items-per-page="10"
      class="elevation-1"
    >
      <template v-slot:[`item.actions`]="{ item }">
        <v-icon
          small
          class="mr-2"
          color="success"
          @click="$router.push('/boards/' + item.id)"
        >
          mdi-eye
        </v-icon>
        <v-icon small color="primary" class="mr-2"> mdi-pencil </v-icon>
        <v-icon
          small
          color="error"
          @click="
            board = item;
            dialog = true;
          "
        >
          mdi-delete
        </v-icon>
      </template>
    </v-data-table>
    <confirm-dialog
      :dialog="dialog"
      @close="dialog = false"
      @confirm="deleteBoard()"
      :title="`Delete ${board.name}`"
      :message="`Are you sure you want to delete ${board.name}? Deleting this board will also delete all posts and comments related to the board`"
    />
  </div>
</template>

<script>
import { BoardsApi } from "../../services/boards";
import ConfirmDialog from "../Dialogs/ConfirmDialog";
import { mapActions } from "vuex";
export default {
  components: { ConfirmDialog },
  name: "BoardTable",
  data: () => ({
    dialog: false,
    board: {},
    boards: [],
    headers: [
      {
        text: "[ Category ]",
        align: "start",
        sortable: true,
        value: "category",
      },
      {
        text: "[ Name ]",
        align: "start",
        sortable: true,
        value: "name",
      },
      {
        text: "[ Short Name ]",
        value: "short_name",
        align: "start",
        width: "140px",
      },
      {
        text: "[ Posts ]",
        align: "center",
        sortable: true,
        value: "post_count",
        width: "120px",
      },
      {
        text: "[ Announcements ]",
        align: "center",
        sortable: true,
        value: "announcement_count",
        width: "160px",
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
    this.getBoards();
  },
  methods: {
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
    async getBoards() {
      const res = await BoardsApi.getAllBoards();
      this.boards = res.boards;
    },
    async deleteBoard() {
      try {
        const res = await BoardsApi.deleteBoard(this.board.id);
        this.dialog = false;
        this.boards = this.boards.filter((b) => b.id != this.board.id);
        this.board = {};
        this.addNotification({
          message: res.message,
          type: "success",
        });
      } catch (error) {
        console.error(error);
        this.addNotification({
          message: "Error deleting board",
          type: "error",
        });
      }
    },
  },
};
</script>

<style></style>
