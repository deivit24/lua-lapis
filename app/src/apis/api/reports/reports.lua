local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local models       = require("models")
local Reports      = models.Reports



function action:GET()
  -- Get reports by post id
  local reports = assert_error(Reports:get_post_reports(self.params.post_id))

  return {
    status = ngx.HTTP_OK,
    json = { reports = reports }
  }
end

function action:POST()
  -- Validate parameters
  local params = {
    post_id = self.params.post_id,
    created_at = os.date(),
  }

  params.ip = self.req.headers["X-Real-IP"] or self.req.remote_addr
  trim_filter(params)
  assert_valid(params, Reports.valid_record)

  -- Create user
  local reports = assert_error(Reports:new(params))
  if not reports then
    return {
      status = ngx.HTTP_BAD_REQUEST
    }
  end
  return {
    status = ngx.HTTP_OK,
    json = reports
  }
end

return action
