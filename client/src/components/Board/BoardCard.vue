<template>
  <v-col cols="12" md="4" :key="board.id" class="pa-2">
    <v-card height="180" elevation="0" outlined>
      <v-card-text style="position: relative; height: 100%">
        <h3 class="mb-0 title" @click="$router.push('/boards/' + board.short_name)">
          /{{ board.short_name }}/ - {{ board.name }}
        </h3>
        <p class="mb-0">
          {{ board.subtext }}
        </p>
        <p style="position: absolute; bottom: 30px" class="mb-0">
          [ {{ board.category }} ]
        </p>
        <span style="font-size: 0.8em" class="mb-2">
          Created {{ formatDate(board.created_at) }}
        </span>
        <h4 class="mb-2" style="position: absolute; bottom: 0; right: 15px">
          {{ board.post_count }} Posts
        </h4>
        <h4 class="mb-2" style="position: absolute; bottom: 0; left: 15px">
          {{ board.announcement_count }} Announcements
        </h4>
      </v-card-text>
    </v-card>
  </v-col>
</template>

<script>
import moment from "moment";
import { mapGetters, mapActions } from "vuex";
import { BoardsApi } from "../../services/boards";
export default {
  name: "BoardCard",
  props: {
    board: {
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
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
    async deleteBoard(id) {
      try {
        const res = await BoardsApi.deleteBoard(id);

        this.addNotification({
          message: res.message,
          type: "success",
        });
        this.$emit("remove", id);
      } catch (e) {
        console.error(e);
        this.addNotification({
          message: "Error deleting message",
          type: "error",
        });
      }
    },
    formatDate(date) {
      return moment(date).utc(true).fromNow();
    },
  },
};
</script>

<style scoped>
.title:hover {
  cursor: pointer;
  background: rgba(0, 0, 0, 0.5);
}
</style>
