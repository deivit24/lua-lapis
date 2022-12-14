import { apiService } from "@/services/api";
import authHeader from "@/services/authHeaders";
export const BoardsApi = {
  getAllBoards: async (popular = false) => {
    const res = await apiService.get("/boards", {
      params: { popular: popular },
    });
    return res.data;
  },
  getBoard: async (id) => {
    const res = await apiService.get(`/boards/${id}`, {
      headers: authHeader(),
    });
    return res.data;
  },
  getBoardPosts: async (id, banned = false) => {
    const res = await apiService.get(`/boards/${id}/posts`, {
      params: { banned: banned },
    });
    return res.data;
  },
  getBoardPostComments: async (board_id, post_id, page = 1) => {
    const res = await apiService.get(
      `/boards/${board_id}/posts/${post_id}/comments`,
      {
        params: { page: page },
      }
    );
    return res.data;
  },
  getBoardPostCommentReplies: async (
    board_id,
    post_id,
    comment_id,
    page = 1
  ) => {
    const res = await apiService.get(
      `/boards/${board_id}/posts/${post_id}/comments/${comment_id}`,
      {
        params: { page: page },
      }
    );
    return res.data;
  },
  creatComment: async (board_id, post_id, data) => {
    const res = await apiService.post(
      `/boards/${board_id}/posts/${post_id}/comments`,
      data,
      {
        headers: authHeader(),
      }
    );
    return res.data;
  },
  getAllReports: async (banned = true, comments = false) => {
    const res = await apiService.get(`/reports`, {
      headers: authHeader(),
      params: { banned: banned, comments: comments },
    });
    return res.data;
  },
  createReport: async (board_id, post_id, data) => {
    const res = await apiService.post(
      `/boards/${board_id}/posts/${post_id}/reports`,
      data,
      {
        headers: authHeader(),
      }
    );
    return res.data;
  },
  updateBoard: async (id, data) => {
    const res = await apiService.put(`/boards/${id}`, data);
    return res.data;
  },
  createBoard: async (data) => {
    const res = await apiService.post(`/boards`, data, {
      headers: authHeader(),
    });
    return res.data;
  },
  createBoardPost: async (id, data) => {
    const res = await apiService.post(`/boards/${id}/posts`, data, {
      headers: authHeader(),
    });
    return res.data;
  },
  deleteBoard: async (id) => {
    const res = await apiService.delete(`/boards/${id}`);
    return res.data;
  },
};
