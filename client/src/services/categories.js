import { apiService } from "@/services/api";
import authHeader from "@/services/authHeaders";
export const CategoryAPI = {
  getCategories: async () => {
    const res = await apiService.get("/categories", {
      headers: authHeader(),
    });
    return res.data;
  },
};
