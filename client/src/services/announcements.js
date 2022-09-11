import { apiService } from "@/services/api";
import authHeader from "@/services/authHeaders";
export const AnnouncementsApi = {
  createAnnouncement: async (data) => {
    const res = await apiService.post(`/announcements`, data, {
      headers: authHeader(),
    });
    return res.data;
  },
  deleteAnnouncement: async (id) => {
    const res = await apiService.delete(`/announcements/${id}`);
    return res.data;
  },
};
