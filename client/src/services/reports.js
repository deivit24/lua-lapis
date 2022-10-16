import { apiService } from "@/services/api";
export const ReportsApi = {
  createCommentReport: async (commentId, data) => {
    const res = await apiService.post(`/reports/comments/${commentId}`, data);
    return res.data;
  },
};
