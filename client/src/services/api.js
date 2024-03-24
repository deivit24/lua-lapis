import axios from "axios";
let url = process.env.VUE_APP_URL;
let currentURL = window.location.href;
if (currentURL.includes("nendev")) url = "https://api.nendev.com/api";
const apiService = axios.create({
  baseURL: url,
});

apiService.defaults.headers.common["Content-Type"] = "application/json";
export { apiService };
