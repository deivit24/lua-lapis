<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="12" md="6" class="text-center mt-5">
        <v-skeleton-loader
          v-if="loadingBoard"
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
        <board-announcements
          v-if="isAnnouncement"
          :announcements="board.announcements"
        />

        <span class="error--text">[RULES]</span>
        <ul class="py-2 ml-8 text-left">
          <li v-for="rule in board.rules?.split(',')" :key="rule">
            {{ rule }}
          </li>
        </ul>
      </v-col>
      <v-col
        cols="12"
        md="6"
        id="posts"
        class="mt-5"
        style="height: 90vh; overflow-y: auto; float: left; position: relative"
      >
        <h1 class="text-center">Posts</h1>
        <p class="text-center mb-2 pb-1">1000 Character Limit</p>
        <v-skeleton-loader
          v-if="loadingPosts"
          type="list-item-avatar, divider, list-item-three-line, card-heading, image, actions"
        ></v-skeleton-loader>
        <div v-if="!loadingPosts">
          <template v-for="post in posts">
            <board-post-card :post="post" :key="post.id" />
          </template>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { BoardsApi } from "../services/boards";
import BoardEditor from "../components/Board/BoardEditor";
import BoardPostCard from "../components/Board/BoardPostCard";
import BoardAnnouncements from "../components/Board/BoardAnnouncements";

export default {
  name: "BoardsDetails",
  components: {
    BoardEditor,
    BoardPostCard,
    BoardAnnouncements,
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
    isAnnouncement() {
      if (this.board.announcements?.length > 0) {
        return true;
      } else {
        return false;
      }
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
    async getBoardPosts(id, banned = false) {
      try {
        this.loadingPosts = true;
        const res = await BoardsApi.getBoardPosts(id, banned);
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
