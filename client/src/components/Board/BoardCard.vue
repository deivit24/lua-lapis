<template>
  <v-col cols="12" md="4" :key="board.id" class="pa-2">
    <v-card min-height="220" elevation="0">
      <v-card-text>
        <h3 class="mb-0 title" @click="$router.push('/boards/' + board.id)">
          /{{ board.short_name }}/ - {{ board.name }}
        </h3>
        <span style="font-size: 0.8em" class="mb-2">
          {{ board.subtext }}
        </span>
        <p class="mb-0 mt-2">Rules</p>
        <div v-html="board.rules"></div>
      </v-card-text>
      <v-card-actions v-if="authUser?.role >= 8">
        <v-spacer></v-spacer>
        <v-btn x-small text color="error" @click="deleteBoard(board.id)">
          [ DELETE ]
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-col>
</template>

<script>
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
  },
};
</script>

<style scoped>
.title:hover {
  cursor: pointer;
  background: rgba(0, 0, 0, 0.5);
}
</style>
