local lapis   = require "lapis"
local capture = require("lapis.application").capture_errors_json
local r2      = require("lapis.application").respond_to
local handle  = require("utils.error").handle
local app     = lapis.Application()
app.__base    = app
app.name      = "api.todos."
app.path      = "/api/todos"

app:match("todos", "", capture({ on_error = handle, r2(require "apis.api.todos.todos") }))
app:match("todo", "/:name", capture({ on_error = handle, r2(require "apis.api.todos.todo") }))

return app
