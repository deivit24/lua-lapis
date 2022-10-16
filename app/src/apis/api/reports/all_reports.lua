local ngx                = _G.ngx
local action             = setmetatable({}, require "apis.api.internal.action_base")
local assert_error       = require("lapis.application").assert_error
local assert_valid       = require("lapis.validate").assert_valid
local trim_filter        = require("lapis.util").trim_filter
local models             = require("models")
local Reports            = models.Reports
local parse_query_string = require("lapis.util").parse_query_string


function action:GET()
  -- Get reports by post id
  local comments = parse_query_string(self.req.parsed_url.query).comments
  local reports
  if comments == "false" then
    reports = assert_error(Reports:all_reports())
  else
    reports = assert_error(Reports:all_comment_reports())
  end


  return {
    status = ngx.HTTP_OK,
    json = { reports = reports }
  }
end

return action
