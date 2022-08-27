local config = require("lapis.config")

config("development", {
  port = 9090,
  email_enabled = false,
  postgres = {
    host = "127.0.0.1",
    port = "5432",
    user = "postgres",
    database = "lapis"
  }
})

