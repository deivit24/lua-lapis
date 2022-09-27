local db     = require("lapis.db")
local schema = require("lapis.db.schema")
local types  = schema.types
local config = require("lapis.config").get()
local seed   = require("seeder")
local bcrypt = require "bcrypt"

return {
  [100] = function()
    schema.create_table("todo", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "name", types.varchar },
      { "done", types.boolean({ default = false }) },
      { "created", types.integer({ default = os.time() }) },
      { "edited", types.integer({ null = true }) }
    })
  end,
  [120] = function()
    schema.create_table("users", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "username", types.varchar { unique = true } },
      { "password", types.varchar },
      { "api_key", types.varchar { default = "00000000-0000-0000-0000-000000000000" } },
      { "role", types.integer {} }
    })

    schema.create_table("categories", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "name", types.varchar { unique = true } },
      { "created_at", types.time },
    })


    schema.create_table("boards", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "category_id", types.foreign_key },
      { "short_name", types.varchar { unique = true } },
      { "name", types.varchar { unique = true } },
      { "subtext", types.varchar { default = "" } },
      { "rules", types.text { default = "" } },
      { "anon_name", types.varchar { default = "Anonymous" } },
      { "total_posts", types.integer { default = 0 } },
      { "text_only", types.boolean { default = false } },
      { "draw", types.boolean { default = false } },
      { "thread_file", types.boolean { default = true } },
      { "thread_comment", types.boolean { default = false } },
      { "thread_file_limit", types.integer { default = 100 } },
      { "post_file", types.boolean { default = false } },
      { "post_comment", types.boolean { default = false } },
      { "post_limit", types.integer { default = 250 } },
      { "archive", types.boolean { default = false } },
      { "created_at", schema.types.time },
    })

    schema.create_table("posts", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "board_id", types.integer },
      { "user_id", types.integer { null = true } },
      { "created_at", schema.types.time },
      { "ip", types.varchar },
      { "body", types.text { null = true } },
      { "name", types.varchar { null = true } },
      { "subject", types.varchar { null = true } },
      { "password", types.varchar { null = true } },
      { "file_name", types.varchar { null = true } },
      { "file_base64", types.text { null = true } },
      { "file_size", types.integer { null = true } },
      { "lewd", types.boolean { null = true } },
      { "banned", types.boolean { default = false } }
    })

    schema.create_table("comments", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "post_id", types.integer },
      { "created_at", types.time },
      { "user_id", types.integer { null = true } },
      { "ip", types.varchar },
      { "body", types.text { null = true } },
      { "name", types.varchar { null = true, default = "Anon User" } },
      { "file_name", types.varchar { null = true } },
      { "file_base64", types.text { null = true } },
      { "file_size", types.integer { null = true } },
      { "lewd", types.boolean { null = true } },
      { "banned", types.boolean { default = false } }
    })

    schema.create_table("reports", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "ip", types.varchar },
      { "post_id", types.integer },
      { "created_at", types.time },
    })


    schema.create_table("announcements", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "board_id", types.integer { null = true } },
      { "text", types.varchar },
      { "type", types.varchar { default = "info" } }
    })

    if config.site_name == "[DEVEL] Lapis" then
      seed(db, config.secret, bcrypt)
    end
  end
}
