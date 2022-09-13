<template>
  <v-list class="pl-5">
    <template v-for="comment in comments">
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
          </v-list-item-title>
          <v-list-item-subtitle
            class="mt-2"
            v-html="comment.body"
          ></v-list-item-subtitle>
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
  methods: {
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
  },
};
</script>

<style></style>
