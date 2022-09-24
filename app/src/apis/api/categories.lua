local lapis       = require "lapis"
local capture     = require("lapis.application").capture_errors_json
local json_params = require("lapis.application").json_params
local r2          = require("lapis.application").respond_to
local handle      = require("utils.error").handle
local app         = lapis.Application()
app.__base        = app
app.name          = "api.categories."
app.path          = "/api/categories"

app:match("categories", "", capture({ on_error = handle, json_params(r2(require "apis.api.categories.categories")) }))


return app
