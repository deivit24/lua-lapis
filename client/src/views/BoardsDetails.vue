<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="12" class="text-center mt-5">
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
        <v-btn
          v-if="!showEditor"
          text
          class="mt-2"
          color="primary"
          @click="showEditor = true"
          >[ Create a Post ]</v-btn
        >
        <v-btn
          v-if="isAuth && authUser.role >= 8"
          text
          class="mt-2"
          color="warning"
          @click="annDialog = true"
          >[ New Announcement ]</v-btn
        >
        <board-editor
          v-if="showEditor"
          :board-id="board.id"
          @newPost="addPost"
          class="my-3"
        />
        <board-announcements
          v-if="isAnnouncement"
          :announcements="board.announcements"
        />
        <board-announcements-create
          :create-dialog="annDialog"
          @close="annDialog = false"
          :board-id="board.id"
          @add="addAnnouncement"
        />
        <v-dialog v-model="dialog" width="400px" persistent>
          <v-card>
            <v-card-title class="error--text"> [RULES] </v-card-title>
            <v-card-text>
              <ul class="py-2 text-left">
                <li v-for="rule in board.rules?.split(',')" :key="rule">
                  {{ rule }}
                </li>
              </ul>
              <span>Do you agree to abide by these rules?</span>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn small text color="error" @click="$router.push('/')"
                >[ I DISAGREE ]</v-btn
              >
              <v-btn small text color="success" @click="dialog = false"
                >[ I AGREE ]</v-btn
              >
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-col>
      <v-col cols="12" id="posts" class="mt-5">
        <v-skeleton-loader
          v-if="loadingPosts"
          type="list-item-avatar, divider, list-item-three-line, card-heading, image, actions"
        ></v-skeleton-loader>
        <div v-if="!loadingPosts">
          <template v-for="post in posts">
            <board-post-card :post="post" :key="post.id" />
          </template>
        </div>
        <div v-if="Object.keys(posts).length === 0">
          <p class="text-center mb-2 pb-1">
            There are no posts on this board yet
          </p>
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
import { mapGetters, mapActions } from "vuex";
import BoardAnnouncementsCreate from "../components/Board/BoardAnnouncementsCreate";
export default {
  name: "BoardsDetails",
  components: {
    BoardEditor,
    BoardPostCard,
    BoardAnnouncements,
    BoardAnnouncementsCreate,
  },
  data: () => ({
    board: {},
    showEditor: false,
    dialog: false,
    annDialog: false,
    loadingBoard: false,
    loadingPosts: false,
    posts: [],
  }),
  created() {
    this.dialog = true;
    this.getBoardDetails(this.$route.params.id);
    this.getBoardPosts(this.$route.params.id);
  },
  computed: {
    ...mapGetters({
      authUser: "auth/user",
      isAuth: "auth/isLoggedIn",
    }),
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
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
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
    addAnnouncement(announcement) {
      this.board.announcements.unshift(announcement);
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
      this.showEditor = false;
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
