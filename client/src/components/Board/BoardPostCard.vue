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
    </v-card-text>
    <v-card-actions v-if="authUser?.role >= 8">
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
  data: () => ({
    boardPost: {},
  }),
  created() {
    this.boardPost = this.post;
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
    removeLewd() {
      this.boardPost.lewd = false;
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
