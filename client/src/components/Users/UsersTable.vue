<template>
  <div>
    <v-data-table
      :headers="headers"
      :items="users"
      :items-per-page="10"
      class="elevation-1"
    >
      <template v-slot:[`item.actions`]="{ item }">
        <v-icon
          small
          class="mr-2"
          color="success"
          @click="$router.push('/users/' + item.short_name)"
        >
          mdi-eye
        </v-icon>
        <v-icon small color="primary" class="mr-2"> mdi-pencil </v-icon>
        <v-icon
          small
          color="error"
          @click="
            user = item;
            dialog = true;
          "
        >
          mdi-delete
        </v-icon>
      </template>
    </v-data-table>
    <confirm-dialog
      :dialog="dialog"
      @close="dialog = false"
      @confirm="deleteUser()"
      :title="`Delete ${user.username}`"
      :message="`Are you sure you want to delete ${user.username}? Deleting this user will also delete all posts and comments related to the board`"
    />
  </div>
</template>

<script>
import { UsersApi } from "../../services/users";
import ConfirmDialog from "../Dialogs/ConfirmDialog";
import { mapActions } from "vuex";
export default {
  components: { ConfirmDialog },
  name: "UsersTable",
  data: () => ({
    dialog: false,
    user: {},
    users: [],
    headers: [
      {
        text: "[ Username ]",
        align: "start",
        sortable: true,
        value: "username",
      },
      {
        text: "",
        value: "actions",
        align: "end",
        sortable: false,
      },
    ],
  }),
  created() {
    this.getUsers();
  },
  methods: {
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
    async getUsers() {
      const res = await UsersApi.getAllUsers();
      this.users = res;
    },
    async deleteUser() {
      try {
        this.dialog = false;
        this.users = this.users.filter((u) => u.id != this.user.id);
        this.user = {};
        this.addNotification({
          message: "successfully deleted user",
          type: "success",
        });
      } catch (error) {
        console.error(error);
        this.addNotification({
          message: "Error deleting board",
          type: "error",
        });
      }
    },
  },
};
</script>

<style></style>
