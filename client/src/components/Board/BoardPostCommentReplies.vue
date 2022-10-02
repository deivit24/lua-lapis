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
  },
  data: () => ({
    replies: [],
  }),
  watch: {
    async show(val) {
      if (val) await this.getReplies();
    },
  },
  methods: {
    async getReplies() {
      const res = await BoardsApi.getBoardPostCommentReplies(
        1,
        this.postId,
        this.commentId,
        1
      );
      this.replies = res.replies;
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
