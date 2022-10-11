<template>
  <div class="px-2 mt-2">
    <v-alert
      v-for="announcement in announcements"
      :key="announcement.id"
      dense
      border="left"
      colored-border
      :dismissible="isAuth && authUser.role >= 8"
      @input="dismiss(announcement.id)"
      :type="announcement.type"
    >
      [ {{ announcement.text }} ]
    </v-alert>
  </div>
</template>

<script>
import { AnnouncementsApi } from "../../services/announcements";
import { mapGetters, mapActions } from "vuex";
export default {
  name: "BoardAnnouncements",
  props: {
    announcements: {
      type: Array,
      default: () => [],
    },
  },
  computed: {
    ...mapGetters({
      authUser: "auth/user",
      isAuth: "auth/isLoggedIn",
    }),
  },
  methods: {
    ...mapActions({
      addNotification: "notifications/addNotification",
    }),
    async dismiss(id) {
      try {
        const res = await AnnouncementsApi.deleteAnnouncement(id);
        this.addNotification({
          message: "Announcement " + res.message,
          type: "success",
        });
      } catch (error) {
        console.error(error);
      }
    },
  },
};
</script>

<style></style>
