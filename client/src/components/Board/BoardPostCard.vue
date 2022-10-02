<template>
  <v-card :key="boardPost.id" outlined class="my-2 mx-auto">
    <v-card-title v-if="boardPost.subject">
      {{ boardPost.subject }}
    </v-card-title>
    <v-card-subtitle>
      Posted by
      <strong>
        [
        <v-icon class="mr-2" color="primary" v-if="boardPost.user_id > 0" small
          >mdi-account</v-icon
        >{{ boardPost.name }} ]</strong
      >
      -
      {{ formatDate(boardPost.created_at) }}
    </v-card-subtitle>

    <v-card-text>
      <v-row no-gutters>
        <v-col cols="4" v-if="boardPost.file_base64">
          <v-img
            contain
            height="auto"
            class="px-3"
            :class="lewdClass"
            width="100%"
            v-if="boardPost.file_base64"
            :src="boardPost.file_base64"
          >
          </v-img>
        </v-col>
        <v-col :cols="boardPost.file_base64 ? 8 : 12">
          <div :class="lewdClass" v-html="boardPost.body"></div>
        </v-col>
      </v-row>

      <v-expand-transition>
        <div v-show="show" class="mt-2">
          <v-divider></v-divider>

          <v-card-text>
            <board-comment-editor
              ref="commentEditor"
              @close="show = false"
              @submit="submitComment"
            />
          </v-card-text>
        </div>
      </v-expand-transition>
    </v-card-text>
    <v-card-actions v-if="!show && !isPreview">
      <v-tooltip top>
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            x-small
            v-bind="attrs"
            v-on="on"
            @click="report"
            text
            color="warning"
          >
            [ REPORT ]
          </v-btn>
        </template>
        <span>[ report post ]</span>
      </v-tooltip>
      <v-btn
        x-small
        text
        v-if="boardPost.lewd"
        color="success"
        @click="removeLewd"
      >
        [ I'm 18 ]
      </v-btn>
      <v-spacer></v-spacer>
      <v-btn x-small text color="primary" @click="show = true">
        [ COMMENT ]
      </v-btn>
      <v-btn v-if="authUser?.role >= 8" x-small text color="error">
        [ DELETE ]
      </v-btn>
    </v-card-actions>
    <board-post-comments
      :comments="comments"
      v-if="!isPreview"
      ref="postComments"
      @submit="submitReply"
    />
  </v-card>
</template>

<script>
import moment from "moment";
import { mapGetters, mapActions } from "vuex";
import { BoardsApi } from "../../services/boards";
import BoardPostComments from "./BoardPostComments.vue";
import BoardCommentEditor from "./BoardCommentEditor.vue";
export default {
  components: { BoardPostComments, BoardCommentEditor },
  name: "BoardPostCard",
  props: {
    post: {
      type: Object,
      default: () => {},
    },
    isPreview: {
      type: Boolean,
      default: false,
    },
  },
  data: () => ({
    boardPost: {},
    comments: [],
    comment: "",
    show: false,
  }),
  created() {
    this.boardPost = this.post;
    this.getComments(this.boardPost.board_id, this.boardPost.id);
  },
  computed: {
    ...mapGetters({
      authUser: "auth/user",
      isAuth: "auth/isLoggedIn",
    }),
    lewdClass() {
      if (this.boardPost.lewd) return "lewdClass";
      return "";
    },
  },
  methods: {
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
    async getComments(boardId = 1, postId) {
      const res = await BoardsApi.getBoardPostComments(boardId, postId);
      if (res.comments.length > 0) {
        this.comments = res.comments;
      } else {
        this.comments = [];
      }
    },
    removeLewd() {
      this.boardPost.lewd = false;
    },
    async report() {
      try {
        await BoardsApi.createReport(
          this.boardPost.board_id,
          this.boardPost.id,
          {}
        );
        this.addNotification({
          message: "Post Successfully reported",
          type: "success",
        });
      } catch (error) {
        console.error(error);
        this.addNotification({
          message: "Post already reported",
          type: "error",
        });
      }
    },
    async submitComment(comment, commentId = 0) {
      try {
        this.comment = comment;
        const data = {
          body: this.comment,
          comment_id: commentId,
        };
        const res = await BoardsApi.creatComment(
          this.boardPost.board_id,
          this.boardPost.id,
          data
        );
        res.comment.post_id = parseInt(res.comment.post_id);
        if (res.comment.comment_id == 0) {
          this.comments.push(res.comment);
          this.comments.sort(function (a, b) {
            return b.id - a.id;
          });
        }

        this.comment = "";
        this.$refs.commentEditor.reset();
      } catch (error) {
        console.error(error);
      }
    },
    async submitReply(data) {
      try {
        const res = await BoardsApi.creatComment(
          this.boardPost.board_id,
          this.boardPost.id,
          data
        );
        console.log(res.comment);

        await this.$refs.postComments.showReplies(res.comment.comment_id, true);
      } catch (error) {
        console.error(error);
      }
    },
  },
};
</script>

<style scoped>
.lewdClass {
  text-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
  filter: blur(20px);
  -webkit-filter: blur(20px);
}
</style>
