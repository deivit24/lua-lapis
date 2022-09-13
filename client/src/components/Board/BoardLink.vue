<template>
  <div class="text-center">
    <v-dialog v-model="boardDialog" width="500px">
      <v-card outlined>
        <v-form ref="form" v-model="valid" lazy-validation>
          <v-card-title> Add Link </v-card-title>
          <v-card-text>
            <v-text-field
              v-model="updatedLinkText"
              :rules="[rules[0]]"
              placeholder="Enter Text"
            />
            <v-text-field
              v-model="updatedLink"
              :rules="[rules[0], rules[1]]"
              placeholder="Enter Link"
            />
          </v-card-text>
          <v-card-actions class="justify-end">
            <v-btn color="red" text @click.stop="$emit('close')">
              Nevermind
            </v-btn>
            <v-btn
              color="indigo"
              :disabled="!valid"
              text
              @click="$emit('addLink', updatedLink, updatedLinkText)"
            >
              Save
            </v-btn>
          </v-card-actions>
        </v-form>
      </v-card>
    </v-dialog>
  </div>
</template>
<script>
/* eslint-disable */
export default {
  name: "BoardLink",
  props: {
    dialog: {
      type: Boolean,
      require: true,
    },
    link: {
      type: String,
      default: "",
    },
    linkText: {
      type: String,
      default: "",
    },
  },
  data() {
    const self = this;
    return {
      boardDialog: false,
      updatedLink: "",
      updatedLinkText: "",
      valid: true,
      rules: [
        (value) => !!value || "Required.",
        (value) => self.isURL(value) || "URL is not valid",
      ],
    };
  },
  watch: {
    dialog(val) {
      console.log(val);
      this.boardDialog = val;
    },
  },
  created() {
    console.log("moneted");
    this.updatedLink = this.link;
    this.updatedLinkText = this.linkText;
  },
  methods: {
    isURL(str) {
      let url;
      try {
        url = new URL(str);
      } catch (_) {
        return false;
      }
      return url.protocol === "http:" || url.protocol === "https:";
    },
  },
};
</script>
