local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local models       = require("models")
local Categories   = models.categories

function action:GET()
  -- Get all Categories
  local categories = assert_error(Categories:get_all())
  return {
    status = ngx.HTTP_OK,
    json = {
      categories = categories
    }
  }
end

return action
