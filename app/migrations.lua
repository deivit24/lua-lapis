local db     = require("lapis.db")
local schema = require("lapis.db.schema")
local types  = schema.types

return {
  [100] = function()
    schema.create_table("todo", {
      { "id", types.serial { unique = true, primary_key = true } },
      { "name", types.varchar },
      { "done", types.boolean({ default = false }) },
    })
    db.insert("todo", {
      done = false,
      name = "Walk the dog"
    })
    db.insert("todo", {
      done = false,
      name = "Feed the cat"
    })
    db.insert("todo", {
      done = false,
      name = "Take a nap"
    })
    db.insert("todo", {
      done = false,
      name = "shit"
    })
  end
}
