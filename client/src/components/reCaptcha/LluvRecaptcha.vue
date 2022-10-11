<template>
  <div class="d-flex flex-column justify-center align-center my-2">
    <vue-recaptcha
      ref="recaptcha"
      sitekey="6Lec914iAAAAANeMKILk4IS1v6usNdJyG47q785G"
      @verify="onVerify"
      @expired="onExpired"
      @error="onError"
      @render="onRender"
    >
    </vue-recaptcha>
    <p class="caption mt-3">
      [ Tired of reCAPTCHA? Consider being a user to always bypass ]
    </p>
  </div>
</template>

<script>
import { VueRecaptcha } from "vue-recaptcha";
export default {
  name: "LluvRecaptcha",
  components: { VueRecaptcha },
  data: () => ({
    expired: false,
  }),
  methods: {
    onEvent() {
      // when you need a reCAPTCHA challenge
      this.$refs.recaptcha.execute();
    },
    onVerify(response) {
      console.log("Verify: " + response);
      this.$emit("verified");
    },
    onExpired: function () {
      console.log("Expired");
      this.$emit("resetVerified");
    },
    onError: function (error) {
      console.log("Error", error);
    },
    onRender() {
      this.$refs.recaptcha.reset();
      this.$emit("resetVerified");
    },
  },
};
</script>
