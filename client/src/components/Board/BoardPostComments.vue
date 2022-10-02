<template>
  <v-list class="pl-5">
    <template v-for="comment in dataComments">
      <v-list-item :key="comment.id" three-line>
        <v-list-item-content>
          <v-list-item-title class="default--text">
            <v-icon
              v-if="comment.user_id > 0"
              color="primary"
              x-small
              class="mr-2"
              >mdi-account</v-icon
            >{{ comment.name }} -
            <span style="font-size: 0.875rem">
              commented {{ formatDate(comment.created_at) }}</span
            >
            -
            <v-btn
              text
              color="primary"
              x-small
              @click="openReply(comment, false)"
              >[ reply ]</v-btn
            >
          </v-list-item-title>
          <v-list-item-subtitle
            class="mt-2"
            v-html="comment.body"
          ></v-list-item-subtitle>
          <board-post-comment-replies
            :show="comment.show"
            :post-id="comment.post_id"
            :comment-id="comment.id"
            @reply="openReply"
            ref="replies"
          />
        </v-list-item-content>
        <v-list-item-action>
          <v-list-item-action-text>
            <v-btn
              text
              v-if="comment.reply_count > 0 && comment.show == true"
              color="warning"
              x-small
              @click="showReplies(comment.id, false)"
            >
              [ - hide replies ]</v-btn
            >
            <v-btn
              text
              v-if="comment.reply_count > 0 && !comment.show"
              color="info"
              x-small
              @click="showReplies(comment.id, true)"
            >
              [ + view replies ]</v-btn
            >
            [ {{ showReplyCount(comment.reply_count) }} replies ]
          </v-list-item-action-text>
        </v-list-item-action>
      </v-list-item>
    </template>
    <reply-dialog
      :dialog="replayDialog"
      :name="replyName"
      @close="closeReply"
      @send="reply"
    />
  </v-list>
</template>

<script>
import moment from "moment";
import ReplyDialog from "../Dialogs/ReplyDialog";
import BoardPostCommentReplies from "./BoardPostCommentReplies";
export default {
  name: "BoardPostComments",
  components: { ReplyDialog, BoardPostCommentReplies },
  props: {
    comments: {
      type: Array,
      default: () => [],
    },
  },
  data: () => ({
    replayDialog: false,
    replyName: "",
    commentId: 0,
    replyId: 0,
    updateKey: 1,
    dataComments: [],
  }),
  watch: {
    comments(val) {
      this.dataComments = val;
    },
  },
  methods: {
    async showReplies(commentId, show, isReply = false) {
      const found = this.dataComments.filter((c) => c.id == commentId)[0];

      if (isReply) {
        await this.$refs.replies
          .filter((c) => c.commentId == commentId)[0]
          .getReplies();
      }
      found.show = show;
    },
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
    openReply(comment, isReply = true) {
      if (isReply) {
        this.replyId = comment.id;
        this.commentId = comment.comment_id;
      } else {
        this.commentId = comment.id;
      }

      this.replyName = comment.name;
      this.replayDialog = true;
    },
    closeReply() {
      this.replayDialog = false;
      this.commentId = 0;
      this.replyId = 0;
      this.replyName = "";
    },
    reply(reply) {
      const data = {
        body: reply,
        comment_id: this.commentId,
        reply_id: this.replyId,
      };
      this.$emit("submit", data);
      this.closeReply();
    },
    showReplyCount(count) {
      if (!count) return 0;
      return count;
    },
  },
};
</script>
