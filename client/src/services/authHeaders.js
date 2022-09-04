export default function authHeader() {
  const pluv = localStorage.getItem("pluv");
  const jsonPluv = JSON.parse(pluv);

  if (jsonPluv == null || jsonPluv == undefined) return {};
  return {
    Authorization: `Basic ${btoa(jsonPluv.username + ":" + jsonPluv.api_key)}`,
  };
}
