<template>
  <v-card :key="post.id" outlined class="my-2 mx-auto">
    <v-card-title v-if="post.subject">
      {{ post.subject }}
    </v-card-title>
    <v-card-subtitle>
      Posted by <strong>{{ post.name }}</strong> -
      {{ formatDate(post.created_at) }}
    </v-card-subtitle>

    <v-card-text>
      <v-img contain height="auto" width="100%" :src="post.file_base64">
      </v-img>
      <div class="mt-3" v-html="post.body"></div>
    </v-card-text>
    <v-card-actions v-if="authUser?.role >= 8">
      <v-spacer></v-spacer>
      <v-btn x-small text color="error"> [ DELETE ] </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import moment from "moment";
import { mapGetters } from "vuex";
export default {
  name: "BoardPostCard",
  props: {
    post: {
      type: Object,
      default: () => {},
    },
  },
  computed: {
    ...mapGetters({
      authUser: "auth/user",
      isAuth: "auth/isLoggedIn",
    }),
  },
  methods: {
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
  },
};
</script>
