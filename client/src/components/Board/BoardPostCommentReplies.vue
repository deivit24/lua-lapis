<template>
  <div class="ml-4" v-if="show">
    <template v-for="reply in replies">
      <v-list-item
        style="border-left: 5px solid lightgrey"
        class="my-2"
        three-line
        :key="reply.id"
      >
        <v-list-item-content>
          <v-list-item-title class="default--text">
            <v-icon
              v-if="reply.user_id > 0"
              color="primary"
              x-small
              class="mr-2"
              >mdi-account</v-icon
            >{{ reply.name }} -
            <span style="font-size: 0.875rem">
              commented {{ formatDate(reply.created_at) }}</span
            >
            -
            <v-btn
              text
              color="primary"
              @click="$emit('reply', reply, true)"
              x-small
              >[ reply ]</v-btn
            >
          </v-list-item-title>
          <v-list-item-subtitle
            class="mt-2"
            v-html="addToReply(reply.body, reply.replyname)"
          >
          </v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
    </template>
    <v-row>
      <v-spacer></v-spacer>
      <v-pagination
        class="mr-4"
        v-model="page"
        color="indigo"
        :length="totalPages"
        prev-icon="mdi-menu-left"
        next-icon="mdi-menu-right"
      ></v-pagination>
    </v-row>
  </div>
</template>

<script>
import moment from "moment";
import { BoardsApi } from "../../services/boards";
export default {
  name: "BoardPostCommentReplies",
  props: {
    show: {
      type: Boolean,
      required: true,
    },
    postId: {
      type: Number,
      required: true,
    },
    commentId: {
      type: Number,
      required: true,
    },
    totalComments: {
      type: Number,
      required: true,
    },
  },
  data: () => ({
    replies: [],
    page: 1,
  }),
  computed: {
    totalPages() {
      console.log(Math.ceil(this.totalComments / 10));
      return Math.ceil(this.totalComments / 10);
    },
  },
  watch: {
    async show(val) {
      this.page = 1;
      if (val) await this.getReplies();
    },
    async page(val) {
      await this.getReplies(val);
    },
  },
  methods: {
    async getReplies(page = 1) {
      const res = await BoardsApi.getBoardPostCommentReplies(
        1,
        this.postId,
        this.commentId,
        page
      );
      this.replies = res.replies.sort((a, b) => a.id - b.id);
    },
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
    addToReply(body, replyName) {
      let name = "";
      if (replyName)
        name = `<p class="mb-0"><strong class="mr-2 primary--text">@${replyName}</strong>`;
      return name + `${body}</p>`;
    },
  },
};
</script>

<style></style>
