import { apiService } from "@/services/api";
import authHeader from "@/services/authHeaders";
export const PostsAPI = {
  getPost: async (id) => {
    const res = await apiService.get(`/posts/${id}`, {
      headers: authHeader(),
    });
    return res.data;
  },
  banPost: async (id, data) => {
    const res = await apiService.put(`/posts/${id}`, data, {
      headers: authHeader(),
    });
    return res.data;
  },
};
