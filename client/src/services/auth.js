import { apiService } from "@/services/api";
export const AuthApi = {
  login: async (data) => {
    const res = await apiService.post("/login", data);
    return res.data;
  },
};
