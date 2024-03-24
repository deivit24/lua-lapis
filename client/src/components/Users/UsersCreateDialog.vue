<template>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-card-title primary-title> [ Create User ] </v-card-title>
      <v-card-text>
        <v-row no-gutters class="text-left pa-2">
          <v-col cols="12">
            <v-select
              return-object
              v-model="role"
              :items="roles"
              item-text="value"
              item-value="id"
              label="Role"
              class="mx-2"
              hide-details
            ></v-select>
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="username"
              label="Username"
              placeholder="Enter Username"
              counter
              maxlength="20"
              class="mx-2"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="password"
              label="Password"
              placeholder="Enter Password"
              counter
              maxlength="20"
              class="mx-2"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="confirm"
              label="Password Confirmation"
              placeholder="Confirm Password"
              counter
              maxlength="20"
              class="mx-2"
            ></v-text-field>
          </v-col>
        </v-row>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn x-small text color="error" @click="$emit('close')">
          [ CANCEL]
        </v-btn>
        <v-btn x-small text color="primary" @click="createUser">
          [ CREATE]
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { UsersApi } from "../../services/users";
import { mapActions } from "vuex";
export default {
  name: "UsersCreateDialog",
  data: () => ({
    dialog: false,
    username: "",
    password: "",
    confirm: "",
    role: null,
    roles: [
      {
        id: 1,
        value: "User",
      },
      {
        id: 6,
        value: "Janitor",
      },
      {
        id: 7,
        value: "MOD",
      },
      {
        id: 8,
        value: "Admin",
      },
      {
        id: 9,
        value: "Owner",
      },
    ],
  }),
  props: {
    createDialog: {
      type: Boolean,
      required: true,
    },
  },
  watch: {
    createDialog(val) {
      this.dialog = val;
    },
  },
  methods: {
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
    async createUser() {
      try {
        const data = this.createData();
        await UsersApi.createUser(data);
        this.$emit("close");
        this.addNotification({
          message: "User Successfully Added",
          type: "success",
        });
        this.reset();
      } catch (error) {
        this.addNotification({
          message: error.response.data[0].message,
          type: "error",
        });
      }
    },
    reset() {
      this.username = "";
      this.password = "";
      this.confirm = "";
    },
    createData() {
      return {
        username: this.username,
        password: this.password,
        confirm: this.confirm,
        role: this.role.id,
      };
    },
  },
};
</script>

<style></style>
