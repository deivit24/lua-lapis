<template>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-card-title primary-title> [ Create Board ] </v-card-title>
      <v-card-text>
        <v-row no-gutters class="text-left pa-2">
          <v-col cols="12">
            <v-select
              return-object
              v-model="category"
              :items="categories"
              item-text="name"
              item-value="id"
              label="Category"
              class="mx-2"
              hide-details
            ></v-select>
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="name"
              label="Name"
              placeholder="JavaScript"
              counter
              maxlength="50"
              class="mx-2"
            ></v-text-field>
          </v-col>
          <v-col cols="12" class="pt-0">
            <v-text-field
              v-model="shortName"
              label="Short Name"
              placeholder="js"
              counter
              maxlength="10"
              class="mx-2 pt-0"
            ></v-text-field>
          </v-col>
          <v-col cols="12" class="pt-0">
            <v-text-field
              v-model="subText"
              label="Sub Text"
              placeholder="If it can be written in javascript, it will be"
              class="mx-2 pt-0"
              counter
              maxlength="50"
            ></v-text-field>
          </v-col>
          <v-col cols="12" class="pt-0">
            <v-textarea
              v-model="rules"
              label="Rules"
              placeholder="Be nice, don't be a dick"
              hint="Each line is a rule. After each rule, start a new line"
              persistent-hint
              class="mx-2 pt-0"
            ></v-textarea>
          </v-col>
        </v-row>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn x-small text color="error" @click="$emit('close')">
          [ CANCEL]
        </v-btn>
        <v-btn x-small text color="primary" @click="createBoard">
          [ CREATE]
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { BoardsApi } from "../../services/boards";
import { CategoryAPI } from "../../services/categories";
import { mapActions } from "vuex";
export default {
  name: "BoardCreateDialog",
  data: () => ({
    dialog: false,
    name: "",
    shortName: "",
    subText: "",
    rules: "",
    category: null,
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
  created() {
    this.getCategories();
  },
  methods: {
    ...mapActions({
      addNotification: "notifications/addNotification",
      reloadBoards: "boards/reloadBoards",
    }),
    async getCategories() {
      const res = await CategoryAPI.getCategories();
      this.categories = res.categories;
      console.log(this.categories);
    },
    async createBoard() {
      try {
        const data = this.createData();
        await BoardsApi.createBoard(data);
        this.$emit("close");
        this.addNotification({
          message: "Board Successfully Added",
          type: "success",
        });
        this.reloadBoards();
        this.reset();
      } catch (error) {
        this.addNotification({
          message: error.response.data[0].message,
          type: "error",
        });
      }
    },
    reset() {
      this.name = "";
      this.shortName = "";
      this.subText = "";
      this.rules = "";
    },
    createData() {
      return {
        name: this.name,
        short_name: this.shortName,
        subtext: this.subText,
        rules: this.rules.split("\n").join(","),
        category_id: this.category.id,
      };
    },
  },
};
</script>

<style></style>
