<template>
  <v-list class="pl-5">
    <template v-for="comment in treeComments">
      <v-list-item :key="comment.id">
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
            - <v-btn text color="primary" x-small>[ reply ]</v-btn>
          </v-list-item-title>
          <v-list-item-subtitle
            class="mt-2"
            v-html="comment.body"
          ></v-list-item-subtitle>
          <div class="ml-4" v-if="comment.children">
            <template v-for="reply in comment.children">
              <v-list-item
                style="border-left: 5px solid lightgrey"
                class="my-2"
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
                    - <v-btn text color="primary" x-small>[ reply ]</v-btn>
                  </v-list-item-title>
                  <v-list-subtitle
                    class="mt-2"
                    v-html="addToReply(reply.body, reply.replyName)"
                  >
                  </v-list-subtitle>
                </v-list-item-content>
              </v-list-item>
            </template>
          </div>
        </v-list-item-content>
      </v-list-item>
    </template>
  </v-list>
</template>

<script>
import moment from "moment";
export default {
  name: "BoardPostComments",
  props: {
    comments: {
      type: Array,
      default: () => [],
    },
  },
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
            node.replyName = list.filter((c) => c.id == node.reply_id)[0].name;
          }
          list[map[node.comment_id]].children.unshift(node);
        } else {
          roots.push(node);
        }
      }
      console.log(roots);
      return roots;
    },
  },
  methods: {
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
    addToReply(body, replyName) {
      let name = "";
      if (replyName) name = `<strong class="mr-2">@${replyName}</strong>`;
      return name + body;
    },
  },
};
</script>

<style></style>
