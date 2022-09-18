local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local models       = require("models")
local Reports      = models.Reports



function action:GET()
  -- Get reports by post id
  local reports = assert_error(Reports:all_reports())

  return {
    status = ngx.HTTP_OK,
    json = { reports = reports }
  }
end

return action
