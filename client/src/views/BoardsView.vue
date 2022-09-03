<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="12" class="mb-2">
        <h1 class="text-center">PLUV BOARD</h1>
      </v-col>
      <template v-for="board in boards">
        <v-col cols="12" md="4" :key="board.id" class="pa-2">
          <v-card height="220">
            <v-card-text>
              <h3 class="mb-0">/{{ board.short_name }}/ - {{ board.name }}</h3>
              <span style="font-size: 0.8em" class="mb-2">
                {{ board.subtext }}
              </span>
              <p class="mb-0 mt-2">Rules</p>
              <div v-html="board.rules"></div>
            </v-card-text>
          </v-card>
        </v-col>
      </template>
    </v-row>
  </v-container>
</template>

<script>
import { BoardsApi } from "../services/boards";
export default {
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
  },
};
</script>

<style></style>
