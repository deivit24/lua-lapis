<template>
  <div class="px-3">
    <h3 class="mb-2">[ Announcements ]</h3>
    <v-alert
      v-for="announcement in announcements"
      :key="announcement.id"
      dense
      border="left"
      colored-border
      :type="announcement.type"
    >
      [ {{ announcement.text }} ]
    </v-alert>
  </div>
</template>

<script>
export default {
  name: "BoardAnnouncements",
  props: {
    announcements: {
      type: Array,
      default: () => [],
    },
  },
};
</script>

<style></style>
