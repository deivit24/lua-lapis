<template>
  <v-dialog width="400px" persistent v-model="replyDialog">
    <v-card flat>
      <v-card-title> Replying to {{ name }} </v-card-title>
      <v-card-text class="pb-0">
        <v-textarea
          counter
          maxlength="255"
          v-model="reply"
          outlined
          placeholder="Write your reply"
        >
        </v-textarea>
      </v-card-text>
      <v-card-actions class="justify-end">
        <v-btn text small color="error" @click="$emit('close')"
          >[ Cancel ]</v-btn
        >
        <v-btn
          text
          small
          color="primary"
          @click="
            $emit('send', reply);
            reply = '';
          "
          >[ Reply ]</v-btn
        >
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: "ReplyDialog",
  props: {
    name: {
      type: String,
      default: "REPLY",
    },
    dialog: {
      type: Boolean,
      required: true,
    },
  },
  data: () => ({
    replyDialog: false,
    reply: "",
  }),
  watch: {
    dialog(val) {
      this.replyDialog = val;
    },
  },
};
</script>

<style></style>
