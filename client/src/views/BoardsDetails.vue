<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="12" md="6" class="text-center mt-5">
        <h1>{{ title }}</h1>
        <span>{{ board.subtext }}</span>
        <br />
        <board-editor :board-id="board.id" @newPost="addPost" class="mt-3" />
        <span class="error--text">[RULES]</span>
        <div v-html="board.rules" class="py-2 ml-8 text-left"></div>
      </v-col>
      <v-col
        cols="12"
        md="6"
        id="posts"
        class="mt-5"
        style="height: 90vh; overflow-y: auto; float: left; position: relative"
      >
        <h1 class="text-center">Posts</h1>
        <p class="text-center mb-2 pb-1">255 Character Limit</p>

        <template v-for="post in posts">
          <v-card :key="post.id" class="my-2 mx-auto">
            <v-card-title v-if="post.subject">
              {{ post.subject }}
            </v-card-title>
            <v-card-subtitle>
              Posted by <strong>{{ post.name }}</strong> - {{ post.created_at }}
            </v-card-subtitle>

            <v-card-text>
              <v-img contain height="auto" width="100%" :src="post.file_base64">
              </v-img>
              <div class="mt-3" v-html="post.body"></div>
            </v-card-text>
          </v-card>
        </template>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { BoardsApi } from "../services/boards";
import BoardEditor from "../components/BoardEditor";

export default {
  name: "BoardsDetails",
  components: {
    BoardEditor,
  },
  data: () => ({
    board: {},
    posts: [],
  }),
  async created() {
    this.posts = [];
    await this.getBoardDetails(this.$route.params.id);
  },
  computed: {
    title() {
      return `/${this.board?.short_name}/ - ${this.board?.name}`;
    },
  },
  methods: {
    async getBoardDetails(id) {
      const res = await BoardsApi.getBoard(id);
      this.board = res;
      await this.getBoardPosts(this.board.id);
    },
    async getBoardPosts(id) {
      const res = await BoardsApi.getBoardPosts(id);
      this.posts = res.posts;
    },
    addPost() {
      this.getBoardPosts(this.board.id);
    },
  },
};
</script>

<style>
#posts::-webkit-scrollbar {
  width: 8px;
}

#posts::-webkit-scrollbar-track {
  border-radius: 10px;
  background: whitesmoke;
}

#posts::-webkit-scrollbar-thumb {
  border-radius: 10px;
  background: black;
}
</style>
