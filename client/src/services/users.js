import { apiService } from "@/services/api";
import authHeader from "@/services/authHeaders";
export const UsersApi = {
  getAllUsers: async () => {
    const res = await apiService.get("/users", {
      headers: authHeader(),
    });
    return res.data;
  },
  createUser: async (data) => {
    const res = await apiService.post(`/users`, data, {
      headers: authHeader(),
    });
    return res.data;
  },
};
