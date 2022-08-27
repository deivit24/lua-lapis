local autoload = require("lapis.util").autoload
return autoload("models")
local schema = require('lapis.db.schema')
local type = schema.types

schema.create_table("todos",{
  {"id", types.serial},
  {"todo", types.varchar},
  {"done", types.boolean({default = false})},
  "PRIMARY KEY (id)"
})
