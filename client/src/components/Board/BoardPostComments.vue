<template>
  <v-list class="pl-5">
    <template v-for="comment in treeComments">
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
          <div class="ml-4" v-if="comment.children.length > 0">
            <template v-for="reply in comment.children">
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
                      @click="openReply(reply)"
                      x-small
                      >[ reply ]</v-btn
                    >
                  </v-list-item-title>
                  <v-list-item-subtitle
                    class="mt-2"
                    v-html="addToReply(reply.body, reply.replyName)"
                  >
                  </v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
            </template>
          </div>
        </v-list-item-content>
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
export default {
  name: "BoardPostComments",
  components: { ReplyDialog },
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
  }),
  computed: {
    treeComments() {
      if (this.comments == {}) return [];
      var list = this.comments;
      var map = {},
        node,
        roots = [],
        i;

      for (i = 0; i < list.length; i += 1) {
        map[list[i].id] = i; // initialize the map
        list[i].children = []; // initialize the children
        list[i].replyName = "";
      }

      for (i = 0; i < list.length; i += 1) {
        node = list[i];
        if (node.comment_id !== 0) {
          // if you have dangling branches check that map[node.comment_id] exists
          if (node.reply_id !== 0) {
            node.replyName = list.filter((c) => c.id == node.reply_id)[0]?.name;
          }
          list[map[node.comment_id]].children.unshift(node);
        } else {
          roots.push(node);
        }
      }
      return roots;
    },
  },
  methods: {
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
    addToReply(body, replyName) {
      let name = "";
      if (replyName)
        name = `<p class="mb-0"><strong class="mr-2">@${replyName}</strong>`;
      return name + `${body}</p>`;
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
  },
};
</script>

<style></style>
