<template>
  <v-card :key="boardPost.id" outlined class="my-2 mx-auto">
    <v-card-title v-if="boardPost.subject">
      {{ boardPost.subject }}
    </v-card-title>
    <v-card-subtitle>
      Posted by <strong>{{ boardPost.name }}</strong> -
      {{ formatDate(boardPost.created_at) }}
    </v-card-subtitle>

    <v-card-text>
      <v-img
        contain
        height="auto"
        :class="lewdClass"
        width="100%"
        v-if="boardPost.file_base64"
        :src="boardPost.file_base64"
      >
      </v-img>
      <div class="mt-3" :class="lewdClass" v-html="boardPost.body"></div>
      <v-expand-transition>
        <div v-show="show" class="mt-2">
          <v-divider></v-divider>

          <v-card-text>
            <v-textarea
              v-model="comment"
              outlined
              placeholder="Start writing a comment"
              counter
              maxlength="255"
              auto-grow
              rows="1"
            ></v-textarea>

            <v-row no-gutters class="justify-end pt-2">
              <v-btn
                x-small
                text
                class="mr-2"
                color="error"
                @click="
                  comment = '';
                  show = false;
                "
              >
                [ DISCARD COMMENT ]
              </v-btn>
              <v-btn x-small outlined color="primary" @click="submitComment">
                [ SUBMIT COMMENT ]
              </v-btn>
            </v-row>
          </v-card-text>
        </div>
      </v-expand-transition>
    </v-card-text>
    <v-card-actions>
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
      <v-btn x-small text color="primary" v-if="!show" @click="show = true">
        [ COMMENT ]
      </v-btn>
      <v-btn v-if="authUser?.role >= 8" x-small text color="error">
        [ DELETE ]
      </v-btn>
    </v-card-actions>

    <v-list class="pl-5">
      <template v-for="comment in comments">
        <v-list-item :key="comment.id">
          <v-list-item-content>
            <v-list-item-title>
              {{ comment.name }} -
              <span style="font-size: 0.875rem">
                commented {{ formatDate(comment.created_at) }}</span
              >
            </v-list-item-title>
            <v-list-item-subtitle v-html="comment.body"></v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </template>
    </v-list>
  </v-card>
</template>

<script>
import moment from "moment";
import { mapGetters } from "vuex";
import { BoardsApi } from "../../services/boards";
export default {
  name: "BoardPostCard",
  props: {
    post: {
      type: Object,
      default: () => {},
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
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
    async getComments(boardId = 1, postId) {
      const res = await BoardsApi.getBoardPostComments(boardId, postId);
      console.log(res.comments);
      if (res.comments.length > 0) {
        this.comments = res.comments;
      } else {
        this.comments = [];
      }
      console.log(this.comments);
    },
    removeLewd() {
      this.boardPost.lewd = false;
    },
    async submitComment() {
      const data = {
        body: this.comment,
      };
      const res = await BoardsApi.creatComment(
        this.boardPost.board_id,
        this.boardPost.id,
        data
      );
      this.comments.push(res.comment);
      this.comments.sort(function (a, b) {
        return b.id - a.id;
      });
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
