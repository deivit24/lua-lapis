<template>
  <v-dialog width="400px" persistent v-model="confirmDialog">
    <v-card flat>
      <v-card-title>
        {{ title }}
      </v-card-title>
      <v-card-text>
        {{ message }}
      </v-card-text>
      <v-card-actions>
        <v-btn text small color="error" @click="$emit('close')"
          >[ Cancel ]</v-btn
        >
        <v-btn text small color="primary" @click="$emit('confirm')"
          >[ Confirm ]</v-btn
        >
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: "ConfirmDialog",
  props: {
    title: {
      type: String,
      default: "Delete",
    },
    message: {
      type: String,
      default: "Are you sure you want to delete this?",
    },
    dialog: {
      type: Boolean,
      required: true,
    },
  },
  data: () => ({
    confirmDialog: false,
  }),
  watch: {
    dialog(val) {
      this.confirmDialog = val;
    },
  },
};
</script>

<style></style>
