import axios from "axios";

const apiService = axios.create({
  baseURL: process.env.VUE_APP_URL,
});

apiService.defaults.headers.common["Content-Type"] = "application/json";
export { apiService };
