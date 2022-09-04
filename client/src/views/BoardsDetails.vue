<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="12" md="6" class="text-center mt-5">
        <v-skeleton-loader
          v-if="loadingBoard"
          v-bind="attrs"
          type="list-item-three-line"
          width="80%"
          class="mx-auto"
        ></v-skeleton-loader>
        <div v-if="!loadingBoard">
          <h1>{{ title }}</h1>
          <span>{{ board.subtext }}</span>
          <br />
        </div>
        <board-editor :board-id="board.id" @newPost="addPost" class="my-3" />
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
        <v-skeleton-loader
          v-if="loadingPosts"
          v-bind="attrs"
          type="list-item-avatar, divider, list-item-three-line, card-heading, image, actions"
        ></v-skeleton-loader>
        <div v-if="!loadingPosts">
          <template v-for="post in posts">
            <v-card :key="post.id" class="my-2 mx-auto">
              <v-card-title v-if="post.subject">
                {{ post.subject }}
              </v-card-title>
              <v-card-subtitle>
                Posted by <strong>{{ post.name }}</strong> -
                {{ post.created_at }}
              </v-card-subtitle>

              <v-card-text>
                <v-img
                  contain
                  height="auto"
                  width="100%"
                  :src="post.file_base64"
                >
                </v-img>
                <div class="mt-3" v-html="post.body"></div>
              </v-card-text>
            </v-card>
          </template>
        </div>
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
    loadingBoard: false,
    loadingPosts: false,
    posts: [],
  }),
  created() {
    this.getBoardDetails(this.$route.params.id);
    this.getBoardPosts(this.$route.params.id);
  },
  computed: {
    title() {
      return `/${this.board?.short_name}/ - ${this.board?.name}`;
    },
  },
  methods: {
    async getBoardDetails(id) {
      try {
        this.loadingBoard = true;
        const res = await BoardsApi.getBoard(id);
        this.board = res;
      } catch (error) {
        console.error(error);
      } finally {
        this.loadingBoard = false;
      }
    },
    async getBoardPosts(id) {
      try {
        this.loadingPosts = true;
        const res = await BoardsApi.getBoardPosts(id);
        this.posts = res.posts;
      } catch (error) {
        console.error(error);
      } finally {
        this.loadingPosts = false;
      }
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
