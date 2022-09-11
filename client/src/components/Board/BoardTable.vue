<template>
  <v-data-table
    :headers="headers"
    :items="boards"
    :items-per-page="5"
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
      <v-icon small color="error" @click="deleteItem(item)">
        mdi-delete
      </v-icon>
    </template>
  </v-data-table>
</template>

<script>
import { BoardsApi } from "../../services/boards";
export default {
  name: "BoardTable",
  data: () => ({
    boards: [],
    headers: [
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
    async getBoards() {
      const res = await BoardsApi.getAllBoards();
      this.boards = res.boards;
    },
  },
};
</script>

<style></style>
