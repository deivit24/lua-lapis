import { apiService } from "@/services/api";
export const TodoApi = {
  getAllTodos: async () => {
    const res = await apiService.get("/todos");
    return res.data;
  },
  getTodo: async (id) => {
    const res = await apiService.get(`/todos/${id}`);
    return res.data;
  },
  updateTodo: async (id, data) => {
    const res = await apiService.put(`/todos/${id}`, data);
    return res.data;
  },
  createTodo: async (data) => {
    const res = await apiService.post(`/todos`, data);
    return res.data;
  },
  deleteTodo: async (id) => {
    const res = await apiService.delete(`/todos/${id}`);
    return res.data;
  },
};
