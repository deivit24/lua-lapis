<template>
  <v-card flat outlined width="100%" v-if="show">
    <v-system-bar color="indigo">
      <strong class="white--text">[ What is LLUV CHAN ? ]</strong>
      <v-spacer></v-spacer>
      <v-btn icon small @click="show = false">
        <v-icon small color="white">mdi-close</v-icon>
      </v-btn>
    </v-system-bar>
    <v-card-text>
      LLUV chan is a simple image-based bulletin board where anyone can post
      comments and share images. This was heavily inspired by
      <a href="https://github.com/karai17/lapis-chan" target="_blank"
        >lapis-chan</a
      >. There are boards dedicated to a variety of programming topics, from web
      development to game development. Users do not need to register an account
      before participating in the community. Feel free to click on a board below
      that interests you and jump right in! LLUV stands for Lapis, Lua and Vue.
      It is the stack used to create this app.
    </v-card-text>
    <v-card-actions>
      <v-spacer></v-spacer>
      <v-btn text color="primary" @click="$emit('setRules')" x-small
        >[ Rules ]</v-btn
      >
      <v-btn text x-small @click="$emit('setFAQs')">[ FAQ ]</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  name: "InfoLluv",
  data: () => ({
    show: true,
  }),
};
</script>

<style></style>
