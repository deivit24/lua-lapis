import { apiService } from "@/services/api";
import dataHeader from "@/services/headers";
export const BoardsApi = {
  getAllBoards: async () => {
    const res = await apiService.get("/boards");
    return res.data;
  },
  getBoard: async (id) => {
    const res = await apiService.get(`/boards/${id}`, {
      headers: dataHeader(),
    });
    return res.data;
  },
  getBoardPosts: async (id) => {
    const res = await apiService.get(`/boards/${id}/posts`, {
      headers: dataHeader(),
    });
    return res.data;
  },
  updateBoard: async (id, data) => {
    const res = await apiService.put(`/boards/${id}`, data, {
      headers: dataHeader(),
    });
    return res.data;
  },
  createBoard: async (data) => {
    const res = await apiService.post(`/boards`, data, {
      headers: dataHeader(),
    });
    return res.data;
  },
  createBoardPost: async (id, data) => {
    const res = await apiService.post(`/boards/${id}/posts`, data, {
      headers: dataHeader(),
    });
    return res.data;
  },
  deleteBoard: async (id) => {
    const res = await apiService.delete(`/boards/${id}`);
    return res.data;
  },
};
