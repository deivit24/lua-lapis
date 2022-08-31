import { apiService } from "@/services/api";
import dataHeader from "@/services/headers";
export const TodoApi = {
  getAllTodos: async () => {
    const res = await apiService.get("/todos");
    return res.data;
  },
  getTodo: async (id) => {
    const res = await apiService.get(`/todos/${id}`, {
      headers: dataHeader(),
    });
    return res.data;
  },
  updateTodo: async (id, data) => {
    const res = await apiService.put(`/todos/${id}`, data, {
      headers: dataHeader(),
    });
    return res.data;
  },
  createTodo: async (id, data) => {
    const res = await apiService.post(`/todos/${id}`, data, {
      headers: dataHeader(),
    });
    return res.data;
  },
};
