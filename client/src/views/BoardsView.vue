<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="12" class="d-flex flex-column align-center justify-center">
        <h1 class="text-center">Lapis Lua Vue [LLUV STACK]</h1>
        <span style="font-size: 16px">All Boards</span>
      </v-col>
      <template v-for="board in boards">
        <board-card :board="board" :key="board.id" @remove="removeCard" />
      </template>
    </v-row>
  </v-container>
</template>

<script>
import BoardCard from "../components/Board/BoardCard";
import { BoardsApi } from "../services/boards";
export default {
  components: { BoardCard },
  name: "BoardsView",
  data: () => ({
    boards: [],
  }),
  created() {
    this.getBoards();
  },
  methods: {
    async getBoards() {
      const res = await BoardsApi.getAllBoards();
      this.boards = res.boards;
    },
    removeCard(id) {
      this.boards = this.boards.filter((b) => b.id != id);
    },
  },
};
</script>
