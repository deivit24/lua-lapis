import axios from "axios";

const apiService = axios.create({
  baseURL: process.env.VUE_APP_URL,
});

export { apiService };
