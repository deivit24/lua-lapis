local lapis       = require "lapis"
local capture     = require("lapis.application").capture_errors_json
local json_params = require("lapis.application").json_params
local r2          = require("lapis.application").respond_to
local handle      = require("utils.error").handle
local app         = lapis.Application()
app.__base        = app
app.name          = "api.boards."
app.path          = "/api/boards"

app:match("boards", "", capture({ on_error = handle, json_params(r2(require "apis.api.boards.boards")) }))
app:match("board", "/:id", capture({ on_error = handle, json_params(r2(require "apis.api.boards.board")) }))
app:match("posts", "/:board_id/posts", capture({ on_error = handle, json_params(r2(require "apis.api.posts.posts")) }))
app:match("comments", "/:board_id/posts/:post_id/comments",
  capture({ on_error = handle, json_params(r2(require "apis.api.comments.comments")) }))
app:match("comment", "/:board_id/posts/:post_id/comments/:comment_id",
  capture({ on_error = handle, json_params(r2(require "apis.api.comments.comment")) }))
app:match("reports", "/:board_id/posts/:post_id/reports",
  capture({ on_error = handle, json_params(r2(require "apis.api.reports.reports")) }))

return app
