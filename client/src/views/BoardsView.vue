<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="12" class="d-flex flex-column align-center justify-center">
        <v-img :src="logo" width="50%"> </v-img>

        <InfoLluv />

        <v-card flat outlined width="100%" class="mt-3">
          <v-system-bar color="indigo">
            <strong class="white--text">[ All Boards ]</strong>
            <v-spacer></v-spacer>
            <v-tooltip bottom v-if="!isList">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  v-bind="attrs"
                  v-on="on"
                  icon
                  small
                  @click="isList = true"
                >
                  <v-icon small color="white">mdi-format-list-bulleted</v-icon>
                </v-btn>
              </template>
              <span>Switch to list view</span>
            </v-tooltip>
            <v-tooltip bottom v-if="isList">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  v-bind="attrs"
                  v-on="on"
                  icon
                  small
                  @click="isList = false"
                >
                  <v-icon small color="white">mdi-cards</v-icon>
                </v-btn>
              </template>
              <span>Switch to detiled card view</span>
            </v-tooltip>
          </v-system-bar>
          <v-card-text>
            <BoardList :boards="boards" v-if="isList" />
            <v-row no-gutters v-if="!isList">
              <template v-for="board in boards">
                <board-card
                  :board="board"
                  :key="board.id"
                  @remove="removeCard"
                />
              </template>
            </v-row>
          </v-card-text>
        </v-card>
        <v-card flat outlined width="100%" class="mt-3">
          <v-system-bar color="indigo">
            <strong class="white--text">[ Top Ten Most Popular Boards ]</strong>
          </v-system-bar>
          <v-card-text>
            <v-row no-gutters>
              <template v-for="board in popularBoards">
                <board-card
                  :board="board"
                  :key="board.id"
                  @remove="removeCard"
                />
              </template>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import BoardCard from "../components/Board/BoardCard";
import BoardList from "../components/Board/BoardList";
import { BoardsApi } from "../services/boards";
import { mapGetters } from "vuex";
import WhiteLogo from "../assets/WhiteLogo.png";
import BlackLogo from "../assets/BlackLogo.png";
import InfoLluv from "../components/Info/InfoLLUV.vue";
export default {
  components: { BoardCard, InfoLluv, BoardList },
  name: "BoardsView",
  data: () => ({
    boards: [],
    popularBoards: [],
    logo: WhiteLogo,
    isList: true,
  }),
  async created() {
    await this.getBoards();
  },
  computed: {
    ...mapGetters({
      reload: "boards/reload",
    }),
  },
  watch: {
    "$vuetify.theme.dark"(val) {
      val ? (this.logo = WhiteLogo) : (this.logo = BlackLogo);
    },
    async reload(val) {
      if (val) await this.getBoards();
    },
  },
  methods: {
    async getBoards() {
      const res = await BoardsApi.getAllBoards();
      this.boards = res.boards;
      await this.getPopular();
    },
    removeCard(id) {
      this.boards = this.boards.filter((b) => b.id != id);
    },
    async getPopular() {
      const res = await BoardsApi.getAllBoards(true);
      this.popularBoards = res.boards;
    },
  },
};
</script>
