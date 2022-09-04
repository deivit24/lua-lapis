<template>
  <v-dialog v-model="formDialog" max-width="350">
    <v-card>
      <v-card-title class="text-h5"> New Todo </v-card-title>

      <v-card-text>
        <v-text-field
          v-model="name"
          :rules="rules"
          counter
          hint="This field uses maxlength attribute"
          label="Enter Todo"
        ></v-text-field>
      </v-card-text>

      <v-card-actions>
        <v-spacer></v-spacer>

        <v-btn color="error" text @click="$emit('close')"> Nevermind </v-btn>

        <v-btn color="indigo" text @click="submit"> Add </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: "TodoForm",
  props: {
    dialog: {
      type: Boolean,
      default: false,
    },
  },
  data: () => ({
    name: "",
    rules: [(v) => v.length <= 50 || "Max 50 characters"],
    formDialog: false,
  }),
  watch: {
    dialog(val) {
      this.formDialog = val;
    },
  },
  methods: {
    submit() {
      this.$emit("submit", this.name);
    },
  },
};
</script>

<style></style>
