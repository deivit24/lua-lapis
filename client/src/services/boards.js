import { apiService } from "@/services/api";
import authHeader from "@/services/authHeaders";
export const BoardsApi = {
  getAllBoards: async () => {
    const res = await apiService.get("/boards");
    return res.data;
  },
  getBoard: async (id) => {
    const res = await apiService.get(`/boards/${id}`, {
      headers: authHeader(),
    });
    return res.data;
  },
  getBoardPosts: async (id) => {
    const res = await apiService.get(`/boards/${id}/posts`);
    return res.data;
  },
  updateBoard: async (id, data) => {
    const res = await apiService.put(`/boards/${id}`, data);
    return res.data;
  },
  createBoard: async (data) => {
    const res = await apiService.post(`/boards`, data);
    return res.data;
  },
  createBoardPost: async (id, data) => {
    const res = await apiService.post(`/boards/${id}/posts`, data);
    return res.data;
  },
  deleteBoard: async (id) => {
    const res = await apiService.delete(`/boards/${id}`);
    return res.data;
  },
};
